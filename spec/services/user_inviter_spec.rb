require_relative '../../app/services/user_inviter'
describe UserInviter do 
  let(:current_user) { double :user } 
  let(:user_repository) { double :user_repository } 
  let(:email) { 'test@test.com' }

  it 'makes an invite for a given user' do 
    expect(user_repository).to receive(:invite!).with({email:email}, current_user)
    described_class.call(user_repository, email, current_user)
  end

end
