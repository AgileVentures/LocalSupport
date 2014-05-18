require 'spec_helper'

describe Invitations::Inviter::DeviseUserInviter do
  let(:invited_by) do
    FactoryGirl.create :user, {
        email: 'admin@example.com',
        admin: true
    }
  end

  before { Gmaps4rails.stub(:geocode) }

  let(:org) do
    FactoryGirl.create :organization, {
        email: 'EMAIL@charity.org'
    }
  end

  let(:params) { {organization_id: org.id, email: org.email} }

  context 'success' do
    let(:user) { User.find_by_email org.email.downcase }
    subject { described_class.(params, invited_by) }

    it 'a new user is persisted' do
      invited_by
      expect(-> { subject }).to change(User, :count).by(1)
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

    it 'responds with a hash' do
      expect(subject).to eq({org.id => 'Invited!'})
    end
  end

  context 'failure' do
    let(:params) { {organization_id: org.id, email: ''} }
    subject { described_class.(params, invited_by) }

    it 'new user is NOT persisted' do
      invited_by
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
end