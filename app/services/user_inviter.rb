require_relative 'resend_invitation_enabler'
class UserInviter
  def initialize(user_repository, current_user, devise)
    @user_repository = user_repository
    @current_user = current_user
    @devise = devise
  end

  def invite(email, resend_invitation, organization_id)
    ResendInvitationEnabler.enable(devise, resend_invitation)
    user = user_repository.invite!({email: email}, current_user)
    user.respond_to_invite(organization_id)
  end

  private
  attr_reader :user_repository, :current_user, :devise

end
