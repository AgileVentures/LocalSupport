require 'devise'
require_relative '../../app/services/batch_invite.rb'

describe BatchInvite do
  let(:invite_service) { double :invite_service }
  let(:invite_list) { [{id: 1, email: 'user@email.com'}] }
  let(:invited_by) { double :invited_by }

  subject { BatchInvite.(invite_service, invite_list, invited_by, 'true') }

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

