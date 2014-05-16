module Invitations::Inviter::DeviseResendInvite
  extend self

  def resend_invite(flag)
    Devise.resend_invitation = to_boolean(flag)
  end

  private

  def to_boolean(flag)
    flag.to_s == 'true' ? true : false
  end
end