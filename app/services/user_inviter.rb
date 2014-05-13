module UserInviter
  extend self

  def invite(email, org_id, invited_by)
    user = User.invite!({email: email}, invited_by)
    user.organization_id = org_id
    user.save
    user.extend InvitedUser
    user.status
  end
  alias_method :call, :invite

end

module InvitedUser
  def status
    invited? ? success_message : failure_message
  end

  private

  def invited?
    !errors.any?
  end

  def success_message
    'Invited!'
  end

  def failure_message
    errors.full_messages.map {|msg| sprintf('Error: %s', msg)}.join(' ')
  end
end
