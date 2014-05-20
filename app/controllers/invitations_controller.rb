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

    invites = invites.map do |organization_id, email|
      [organization_id, invite_user(email, organization_id)]
    end.flatten
    debugger
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
