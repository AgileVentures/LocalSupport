module LocalSupport::Invitations::Inviter::DeviseUserInviter
  extend self

  def invite(params, invited_by)
    org_id, email = params.fetch(:id), params.fetch(:email)
    user = User.invite!({email: email}, invited_by) do |user|
      user.organization_id = org_id
    end
    user.extend InvitedUser
    {org_id => user.status}
  end
  alias_method :call, :invite

  private

  module InvitedUser
    def status
      errors.any? ? failure_message : success_message
    end

    private

    def success_message
      'Invited!'
    end

    def failure_message
      errors.full_messages.map {|msg| sprintf('Error: %s', msg)}.join(' ')
    end
  end
end