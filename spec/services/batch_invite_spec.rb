require 'spec_helper'

describe BatchInvite do
  let(:klass) { double :klass }
  let(:gem) { double :gem }
  let(:current_user) { double :current_user }
  let(:honeybee) { double :honeybee }

  before do
    Devise.stub :resend_invitation=
  end

  describe '#initialize' do
    it 'sets the resend_invitation flag on the gem during initialization' do
      expect(flag).to receive(:to_s) { 'true' }
      expect(Devise).to receive(:resend_invitation=).with(true)
      BatchInvite.new(flag)
    end
  end

  describe '#run' do
    it 'sends all the invites and captures all the responses' do
      params = [{id: -1, email: 'user@email.com'}]
      job = double :job
      expect(job).to receive(:invite) { 'Invited' }
      BatchInvite.new(flag).run(current_user, params)
    end
  end

  describe '#to_boolean' do
    it 'tries to cast the flag as a boolean and raises and error if it cannot' do
      expect(flag).to receive(:to_s).exactly(3).times { flag } # #{} implicitly calls to_s
      expect(flag).to receive(:==).exactly(2).times
      expect { Inviter.new(klass, gem, flag) }.to raise_error
    end
  end
end

