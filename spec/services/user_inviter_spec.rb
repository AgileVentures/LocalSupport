require_relative '../../app/services/user_inviter'
describe UserInviter do
  let(:listener) { double :listener, build_response:true}
  let(:user_repository) { double :user_repository }
  let(:current_user) { double :user }
  let(:dom_id) { 'id' }

  let(:email) { 'test@test.com' }

  context 'when the user to invite exists' do 
    let(:user_to_invite) do 
      double(:user_to_invite, present?:false, errors:[], error_message:'')
    end

    it 'makes an invite for a given user' do 
      expect(user_repository).to receive(:invite!).with({email:email}, current_user)
      described_class.new(listener, user_repository, current_user).invite(email)
    end
  end

  context 'when the user to invite doesnt exists' do 
    let(:errors) { double(:errors, any?:true) } 
    let(:user_to_invite) do 
      double(:user_to_invite, present?:true, errors:errors, error_message:'')
    end

    it 'builds message when the email is already taken' do 
      expect(errors).to receive(:add) 
      described_class.new(listener, user_repository, current_user).invite(email, user_to_invite, dom_id)
    end
  end

end
