module Invitations::KeyMapper
  extend self

  def map_keys(params)
    validate_keys(params)
  end
  alias_method :call, :map_keys

  private

  def validate_keys(hash)
    {
        resend_invitation: hash.fetch(:resend_invitation),
        invite_list: validate_invite_list(hash.fetch(:invite_list))
    }
  end

  def validate_invite_list(invites)
    invites.map do |invite|
      {
          org_id: invite.fetch(:id),
          email: invite.fetch(:email)
      }
    end
  end
end