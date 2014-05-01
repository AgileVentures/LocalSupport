require_relative '../../app/services/user_inviter'
describe UserInviter do
  let(:user_repository) { double :user_repository }
  let(:current_user) { double :user }
  let(:invited_user) { double :invited_user }
  let(:devise) { double :devise }
  let(:resend_invitation) { false }
  let(:email) { 'test@test.com' }
  let(:org_id) { -1 }

  it 'makes an invite for a given user' do
    expect(ResendInvitationEnabler).to receive(:enable).with(devise, resend_invitation)
    expect(user_repository).to receive(:invite!).with({email: email}, current_user) { invited_user }
    expect(invited_user).to receive(:respond_to_invite).with(org_id) { 'a message!' }
    expect(
        described_class.new(user_repository, current_user, devise).invite(email, resend_invitation, org_id)
    ).to eq 'a message!'
  end
end

