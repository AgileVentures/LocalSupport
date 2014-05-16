require 'spec_helper'

describe Invitations::Inviter do
  let(:toggler) { Invitations::Inviter::DeviseInviteResender }
  let(:inviter) { Invitations::Inviter::DeviseUserInviter }

  let(:resend_flag) { double :resend_flag }
  let(:invite_hash) { double :invite_hash }
  let(:invited_by) { double :invited_by }
  let(:params) do
    {
        :resend_invitation => resend_flag,
        :invite_list => [invite_hash, invite_hash]
    }
  end

  before do
    allow(toggler).to receive(:call)
    allow(inviter).to receive(:call)
  end

  subject { described_class.(params, invited_by) }

  it 'sends DeviseInviterResender the resend_flag' do
    expect(toggler).to receive(:call).with(resend_flag)
    subject
  end

  it 'maps the invite list with calls to DeviseUserInviter' do
    expect(inviter).to receive(:call).twice.with(invite_hash, invited_by) { 'reply hash' }
    expect(subject).to eq(['reply hash', 'reply hash'])
  end
end