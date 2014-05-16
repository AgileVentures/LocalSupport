module LocalSupport::Invitations::Inviter
  extend self

  def orchestrate_invites(params, invited_by)
    toggle(params.fetch(:resend_invitation))
    params.fetch(:invite_list).map do |invite_hash|
      invite(invite_hash, invited_by)
    end
  end
  alias_method :call, :orchestrate_invites

  private

  def toggle(resend_flag)
    LocalSupport::Invitations::Inviter::DeviseResendInvite.(resend_flag)
  end

  def invite(invite_hash, invited_by)
    LocalSupport::Invitations::Inviter::DeviseUserInviter.(invite_hash, invited_by)
  end
end