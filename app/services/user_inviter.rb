require_relative 'resend_invitation_enabler' 
class UserInviter 
  def initialize(listener, user_repository, current_user, devise)
    @user_repository = user_repository
    @current_user = current_user
    @listener = listener
    @devise = devise
  end

  def invite(email, resend_invitation)
    ResendInvitationEnabler.enable(devise, resend_invitation)
    user = user_repository.invite!({email:email}, current_user)
    user.message_for_invite
  end

  private 
  attr_reader :user_repository, :current_user, :listener, :devise
end
