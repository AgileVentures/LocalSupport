require_relative '../../app/services/inviter'

describe Inviter do
  let(:klass) { double :klass }
  let(:gem) { double :gem }
  let(:flag) { double :flag }
  let(:current_user) { double :current_user }
  let(:honeybee) { double :honeybee }

  before { gem.stub :resend_invitation }

  describe '#initialize' do
    it 'sets the resend_invitation flag on the gem during initialization' do
      expect(flag).to receive(:to_s) { 'true' }
      expect(gem).to receive(:resend_invitation).with(true)
      Inviter.new(klass, gem, flag)
    end
  end

  describe '#rsvp' do
    it 'creates a new instance of klass with #invite!, and then tells it to give its response' do
      expect(klass).to receive(:invite!).with({email: 'honeybee@gmail.com'}, current_user) { honeybee }
      expect(honeybee).to receive(:respond_to_invite).with(-3)
      Inviter.new(klass, gem, true).rsvp('honeybee@gmail.com', current_user, -3)
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

