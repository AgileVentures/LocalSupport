require_relative '../../app/services/batch_invite.rb'

describe BatchInvite do
  let(:to_class) { double :to_class }
  let(:from_class) { double :from_class }
  let(:by_whom) { double :by_whom }
  let(:job) { BatchInvite.new(to_class, from_class, :foreign_key=, by_whom) }
  let(:invite_list) { [{id: 1, email: 'user@email.com'}] }

  describe '#run' do
    before do
      expect(to_class).to receive(:invite!) { to_class }
      expect(to_class).to receive(:errors) { to_class }
    end

    context 'when the invite returns errors' do
      before { expect(to_class).to receive(:any?) { true } }

      it 'returns the error messages' do
        expect(to_class).to receive(:errors) { to_class }
        expect(to_class).to receive(:full_messages) { ['ERROR'] }
        expect(job.run(invite_list)).to eq({1 => 'Error: ERROR'})
      end
    end

    context 'when the invite returns NO errors' do
      before { expect(to_class).to receive(:any?) { false } }

      it 'sets the association and returns a success message' do
        expect(to_class).to receive(:foreign_key=).with(1) { to_class }
        expect(to_class).to receive(:save!)
        expect(job.run(invite_list)).to eq({1 => 'Invited!'})
      end
    end
  end

end

