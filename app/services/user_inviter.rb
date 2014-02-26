class UserInviter 
  def initialize(listener, user_repository, current_user, resend_invitation)
    @user_repository = user_repository
    @current_user = current_user
    @listener = listener
    Devise.resend_invitation = resend_invitation
  end

  def invite(email)
    user = user_repository.invite!({email:email}, current_user)
    build_message_for(user)
  end

  private 
  attr_reader :user_repository, :current_user, :listener, :response

  def build_message_for(user)
    user.errors.any? ? 'Error: ' + user.errors.full_messages.first : 'Invited!'
  end
end
