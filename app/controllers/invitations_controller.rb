class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only
  def create
    flag = params.fetch(:resend_invitation).to_s == 'true' ? true : false
    Devise.resend_invitation = flag
    answers = send_invites_and_gather_answers(params.fetch(:invite_list))
    render json: answers.reduce({}, :update).to_json
  end

  def send_invites_and_gather_answers(invite_list)
    invite_list.map do |invite|
      user = invite_single_user(invite)
      answer = if user.errors.any?
                 user.errors.full_messages.map{|msg| "Error: #{msg}"}.join(' ')
               else
                 'Invited!'
               end
      {invite.fetch(:id) => answer}
    end
  end

  def invite_single_user(invite_params)
    User.invite!({email: invite_params.fetch(:email)}, current_user) do |user|
      user.organization_id = invite_params.fetch(:id)
    end
  end
end
