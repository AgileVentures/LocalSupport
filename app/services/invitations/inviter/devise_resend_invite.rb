module Invitations::Inviter::DeviseResendInvite
  extend self

  def toggle_resend_invite_setting(flag)
    Devise.resend_invitation = to_boolean(flag)
  end
  alias_method :call, :toggle_resend_invite_setting

  private

  def to_boolean(flag)
    flag.to_s == 'true' ? true : false
  end
end