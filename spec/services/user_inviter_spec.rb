require_relative '../../app/services/user_inviter'
describe UserInviter do
  let(:listener) { double :listener }
  let(:user_repository) { double :user_repository }
  let(:current_user) { double :user }
  let(:invited_user) { double(:invited_user, errors:[], message_for_invite:'') } 
  let(:devise) { double :devise } 
  let(:resend_invitation) { false } 
  let(:email) { 'test@test.com' } 
  let(:org_id) { -1 }

  it 'makes an invite for a given user' do 
    expect(user_repository).to receive(:invite!).with({email:email}, current_user) { invited_user } 
    allow(ResendInvitationEnabler).to receive(:enable) 
    described_class.new(listener, user_repository, current_user,devise).invite(email, resend_invitation)
  end

  it 'sets the association between the user and the organization' do
    allow(ResendInvitationEnabler).to receive(:enable) 
    allow(user_repository).to receive(:invite!) { invited_user } 
    expect(invited_user).to receive(:organization_id=).with(org_id)
  end
end

