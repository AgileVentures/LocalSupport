class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only
  def create
    render :json => BatchInvite.(
      UserInviter,
      params.fetch(:values),
      current_user,
      params.fetch(:resend_invitation)
    ).to_json
  end

end
