require 'spec_helper'

describe UserInviter do
  let(:invited_by) do
    FactoryGirl.create :user, {
      email: 'admin@example.com',
      admin: true
    }
  end

  let(:org) do
    FactoryGirl.build :organization, {
      email: 'EMAIL@charity.org'
    }
  end

  context 'success' do
    let(:user) { User.last }
    subject { UserInviter.(org.email, org.id, invited_by) }

    it 'new user is persisted' do
      invited_by
      expect(->{subject}).to change(User, :count).by(1)
    end

    it 'warning: email may be mutated' do
      subject
      expect(user.email).to_not eq org.email
      expect(user.email).to eq org.email.downcase
    end

    it 'associations can be set' do
      subject
      expect(user.organization_id).to eq org.id
    end

    it 'sends a custom email' do
      subject
      email = ActionMailer::Base.deliveries.last
      expect(email.from).to eq ['support@harrowcn.org.uk']
      expect(email.reply_to).to eq ['support@harrowcn.org.uk']
      expect(email.to).to eq [user.email]
      expect(email.cc).to eq ['technical@harrowcn.org.uk']
      expect(email.subject).to eq 'Invitation to Harrow Community Network'
    end
  end

  context 'failure' do
    subject { UserInviter.('', org.id, invited_by) }

    it 'new user is NOT persisted' do
      invited_by
      expect(->{subject}).to change(User, :count).by(0)
    end

    it 'no association is set' do
      expect(org.users.any?).to be false
    end

    it 'sends no email' do
      subject
      expect(ActionMailer::Base.deliveries).to be_empty
    end

    it 'returns the error messages' do
      expect(subject).to eq "Error: Email can't be blank"
    end
  end

  context 'resending invitations' do
    subject { ->{UserInviter.(org.email, org.id, invited_by)} }

    it 'is toggled on by default' do
      subject.call
      expect(ActionMailer::Base.deliveries).to_not be_empty
      ActionMailer::Base.deliveries.clear
      subject.call
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it 'can be toggled off' do
      Devise.resend_invitation = false
      subject.call
      expect(ActionMailer::Base.deliveries).to_not be_empty
      ActionMailer::Base.deliveries.clear
      subject.call
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end

describe InvitedUser do
  let(:user) { FactoryGirl.build :user }
  before { user.extend InvitedUser }

  describe '#status' do
    
    it 'is "Invited!" if there are no errors' do
      expect(user.status).to eq 'Invited!'
    end

    it 'displays an error if there is an error' do
      user.errors.add(:email, 'must not be blank.')
      expect(user.status).to eq 'Error: Email must not be blank.'
    end

    it 'displays all errors if there is more than one error' do
      user.errors.add(:email, 'must not be blank.')
      user.errors.add(:id, 'whatever?')
      expect(user.status).to eq 'Error: Email must not be blank. Error: Id whatever?'
    end
  end
end
