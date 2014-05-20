class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only, tested in a request spec
  def create
    tell_devise_if_okay_to_resend_invitations
    results = invite_users_and_collate_results
    render json: results.to_json
  end

  def invite_users_and_collate_results
    invites = params.fetch(:invite_list)
    invites_dup = invites.dup

    invites_dup.each do |organization_id, email|
      user = invite_user(email, organization_id)
      invites[organization_id] = result_of_inviting user
    end
    invites
  end

  def tell_devise_if_okay_to_resend_invitations
    flag = params.fetch(:resend_invitation).to_s == 'true'
    Devise.resend_invitation = flag
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
