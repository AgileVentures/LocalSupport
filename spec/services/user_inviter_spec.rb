require_relative '../../app/services/user_inviter'
describe UserInviter do
  let(:listener) { double :listener }
  let(:user_repository) { double :user_repository }
  let(:current_user) { double :user }
  let(:invited_user) { double(:invited_user, errors:[]) } 
  let(:email) { 'test@test.com' }

  it 'makes an invite for a given user' do 
    expect(user_repository).to receive(:invite!).with({email:email}, current_user) { invited_user } 
    described_class.new(listener, user_repository, current_user).invite(email)
  end
end

