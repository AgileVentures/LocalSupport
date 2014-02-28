class UserInviter 
  def initialize(listener, user_repository, current_user)
    @user_repository = user_repository
    @current_user = current_user
    @listener = listener
  end

  def invite(email)
    user = user_repository.invite!({email:email}, current_user)
    build_message_for(user)
  end

  private 
  attr_reader :user_repository, :current_user, :listener

  def build_message_for(user)
    user.errors.any? ? 'Error: ' + user.errors.full_messages.first : 'Invited!'
  end
end
