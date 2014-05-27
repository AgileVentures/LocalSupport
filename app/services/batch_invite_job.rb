class BatchInviteJob

  def initialize(params, current_user)
    @resend_invitation = params.fetch(:resend_invitation)
    @invites = params.fetch(:invite_list)
  end

  def run
    tell_devise_if_okay_to_resend_invitations
    invite_users_and_collate_results
  end

  private

  def tell_devise_if_okay_to_resend_invitations
    flag = @resend_invitation.to_s == 'true'
    Devise.resend_invitation = flag
  end

  def invite_users_and_collate_results
    results = @invites.flat_map do |organization_id, email|
      [organization_id, result_of_inviting(invite_user(email, organization_id))]
    end
    Hash[*results]
  end

  def invite_user email, organization_id
    User.invite!({email: email}) do |user|
      user.organization_id = organization_id
    end
  end

  def result_of_inviting user
    if user.errors.any?
      user.errors.full_messages.map{|msg| "Error: #{msg}"}.join(' ')
    else
      'Invited!'
    end
  end
end
