require 'rails_helper'

describe ::BatchInviteJob do
  let(:current_user) { FactoryGirl.create(:user, email: 'superadmin@example.com', superadmin: true) }
  let(:org) { FactoryGirl.create :organisation, email: 'YES@hello.com' }
  let(:params) do
    {invite_list: {org.id => org.email,
                   org.id+1 => org.email},
                   resend_invitation: false}
  end

  before do
    current_user # lazy-loading messes up DB counts
  end

  subject { BatchInviteJob.new(params, current_user).run }

  context 'success' do
    let(:user) { User.find_by_email org.email.downcase }

    it 'a new user is persisted' do
      expect(-> { subject }).to change(User, :count).by(1)
    end

    it 'warning: email may be mutated' do
      subject
      expect(user.email).to_not eq org.email
      expect(user.email).to eq org.email.downcase
    end

    it 'associations can be set' do
      subject
      expect(user.organisation_id).to eq org.id
    end

    it 'sends a custom email' do
      subject
      email = ActionMailer::Base.deliveries.last
      expect(email.from).to eq ['support@harrowcn.org.uk']
      expect(email.reply_to).to eq ['support@harrowcn.org.uk']
      expect(email.to).to eq [user.email]
      expect(email.cc).to eq ['technical@harrowcn.org.uk']
      expect(email.subject).to eq 'Welcome to Harrow Community Network!'
    end

    it 'example response for invites with duplicates' do
      expect(subject).to eq(
        {org.id => 'Invited!',
         (org.id+1) => 'Error: Email has already been taken'}
      )
    end
  end

  context 'failure' do
    let(:params) do
      {invite_list: {org.id => ''},
       resend_invitation: false}
    end

    it 'new user is NOT persisted' do
      expect(-> { subject }).to change(User, :count).by(0)
    end

    it 'no association is set' do
      expect(org.users.any?).to be false
    end

    it 'sends no email' do
      subject
      expect(ActionMailer::Base.deliveries).to be_empty
    end

    it 'responds with a hash' do
      expect(subject).to eq({org.id => "Error: Email can't be blank"})
    end
  end

  context 'resending invitations' do
    let(:job) { ->(params){ BatchInviteJob.new(params, current_user).run } }
    let(:answers) { ->(hash){ hash.to_a.map(&:last) } }

    it 'can be toggled on' do
      params[:resend_invitation] = true
      expect(answers.(job.call(params))).to eq(['Invited!', 'Invited!'])
      expect(answers.(job.call(params))).to eq(['Invited!', 'Invited!'])
    end

    it 'can be toggled off' do
      params[:resend_invitation] = false
      expect(answers.(job.call(params))).to eq(['Invited!',
                                       'Error: Email has already been taken'])
      expect(answers.(job.call(params))).to eq(['Error: Email has already been taken',
                                       'Error: Email has already been taken'])
    end
  end
end
