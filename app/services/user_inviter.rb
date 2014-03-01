class UserInviter 
  def initialize(listener, user_repository, current_user)
    @user_repository = user_repository
    @current_user = current_user
    @listener = listener
  end

  def invite(email)
    user = user_repository.invite!({email:email}, current_user)
    user.message_for_invite
  end

  private 
  attr_reader :user_repository, :current_user, :listener
end
