require 'spec_helper'

describe Invitations do
  let(:key_mapper) { Invitations::KeyMapper }
  let(:inviter) { Invitations::Inviter }

  let(:params) { double :params }
  let(:invited_by) { double :invited_by }

  subject { described_class.(params, invited_by) }

  it 'reduces the results from an array of hashes to a hash' do
    expect(key_mapper).to receive(:call).with(params) { key_mapper }
    expect(inviter).to receive(:call).with(key_mapper, invited_by) do
      [{1=>'a'}, {2=>'b'}]
    end
    expect(subject).to eq(
      {1=>'a', 2=>'b'}
    )
  end
end
