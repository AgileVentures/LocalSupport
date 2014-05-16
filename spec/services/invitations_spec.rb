require 'spec_helper'

describe ::Invitations do

  describe ::Invitations::BatchInviteJob do
    let(:invite_service) { ::Invitations::UserInviter }
    let(:invite_list) { [{id: 1, email: 'user@email.com'}] }
    let(:invited_by) { double :invited_by }

    subject { ::Invitations::BatchInviteJob.('true', invite_list, invited_by) }

    before do
      allow(Devise).to receive(:resend_invitation=)
      allow(invite_service).to receive(:call) { 'Invited!' }
    end

    describe 'when invite_list hashes are missing keys' do
      it 'raises an error if there is no relation_id' do
        invite_list.first.delete :id
        expect(->{subject}).to raise_error 'key not found: :id'
      end

      it 'raises an error if there is no email' do
        invite_list.first.delete :email
        expect(->{subject}).to raise_error 'key not found: :email'
      end
    end

    describe '#run' do
      it 'sets the resend_invitation flag on Devise' do
        expect(Devise).to receive(:resend_invitation=).with(true)
        subject
      end

      it 'calls the service with the required args' do
        expect(invite_service).to receive(:call).with('user@email.com', 1, invited_by)
        subject
      end

      it 'captures the response in a hash' do
        expect(subject).to eq({1 => 'Invited!'})
      end
    end

  end

  describe ::Invitations::UserInviter do
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
      let(:user) { User.find_by_email org.email.downcase }
      subject { ::Invitations::UserInviter.(org.email, org.id, invited_by) }

      it 'a new user is persisted' do
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
      subject { ::Invitations::UserInviter.('', org.id, invited_by) }

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
      subject { ->{::Invitations::UserInviter.(org.email, org.id, invited_by)} }

      it 'is toggled on by default' do
        Devise.resend_invitation = true
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

  describe ::Invitations::InvitedUser do
    let(:user) { FactoryGirl.build :user }
    before { user.extend ::Invitations::InvitedUser }

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

end
