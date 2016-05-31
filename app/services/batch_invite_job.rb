class BatchInviteJob

  def initialize(params, current_user)
    @resend_invitation = params.fetch(:resend_invitation)
    @invites = params.fetch(:invite_list)
    @mail_template = MailTemplate.find_by(name: 'Invitation instructions')
  end

  def run
    tell_devise_if_okay_to_resend_invitations
    purge_deleted_users
    invite_users_and_collate_results
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

  def purge_deleted_users
    User.purge_deleted_users_where(email: @invites.flat_map{ |org_id, email| email.downcase })
  end
end
