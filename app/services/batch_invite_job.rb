class BatchInviteJob

  def initialize(params, current_user)
    @resend_invitation = params.fetch(:resend_invitation)
    @invites = params.fetch(:invite_list)
  end

  def run
    tell_devise_if_okay_to_resend_invitations
    invite_users_and_collate_results
  end

  def self.invite_user org, email
    result = ::BatchInviteJob.new({:resend_invitation => false, :invite_list => {org.id.to_s => email}}, User.first).run
    if result[org.id.to_s] != "Invited!"
      org.error_when_new_org_admin_invited email
    end
  end
  private

  def tell_devise_if_okay_to_resend_invitations
    flag = @resend_invitation.to_s == 'true'
    Devise.resend_invitation = flag
  end

  def invite_users_and_collate_results
    results = @invites.flat_map do |organisation_id, email|
      [organisation_id, result_of_inviting(invite_user(email, organisation_id))]
    end
    Hash[*results]
  end

  def invite_user email, organisation_id
    User.invite!({email: email}) do |user|
      user.organisation_id = organisation_id
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
