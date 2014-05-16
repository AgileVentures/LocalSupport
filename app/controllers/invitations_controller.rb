class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only
  def create
    render :json => ::Invitations::BatchInviteJob.(
      params.fetch(:resend_invitation),
      params.fetch(:invite_list),
      current_user
    ).to_json
  end

end
