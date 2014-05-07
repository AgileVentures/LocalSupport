require_relative '../../app/services/inviter'

describe Inviter do
  let(:klass) { double :klass }
  let(:gem) { double :gem }
  let(:flag) { double :flag }
  let(:current_user) { double :current_user }
  let(:honeybee) { double :honeybee }

  # before { gem.stub :resend_invitation }

describe '#initialize'
  it 'tries to cast the flag as a boolean' do
  end
  
  it 'sets the resend_invitation flag on the gem during initialization' do
    expect(gem).to receive(:resend_invitation).with(flag)
    Inviter.new(klass, gem, true)
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
    # it 'works for stringified versions of "true" and "false"' do
    #   expect { }
    # end

    # it 'works for true booleans' do
    #   expect {  }
    # end
  end
end

