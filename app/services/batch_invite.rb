module BatchInvite
  extend self

  def run(invite_service, invite_list, invited_by, resend_invitation)
    invite_list.each_with_object({}) do |invite, response|
      Devise.resend_invitation = to_boolean(resend_invitation)
      email = invite.fetch(:email)
      relation_id = invite.fetch(:id)
      response[relation_id] = invite_service.(email, relation_id, invited_by)
    end
  end
  alias_method :call, :run

  private

  def to_boolean(resend_invitation)
    resend_invitation.to_s == 'true' ? true : false
  end
end
