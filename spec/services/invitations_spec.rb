require 'spec_helper'

describe Invitations do
  let(:key_mapper) { Invitations::KeyMapper }
  let(:inviter) { Invitations::Inviter }

  let(:array_of_hashes) { [{1=>'a'}, {2=>'b'}] }

  let(:params) { double :params }
  let(:invited_by) { double :invited_by }

  subject { described_class.(params, invited_by) }

  it 'calls to a key mapper and inviter service, then reduces the results' do
    expect(key_mapper).to receive(:call).with(params) { key_mapper }
    expect(inviter).to receive(:call).with(key_mapper, invited_by) { array_of_hashes }
    expect(subject).to eq({1=>'a', 2=>'b'})
  end
end
