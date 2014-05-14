class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only
  def create
    flag = params.fetch(:resend_invitation)
    invite_list = params.fetch(:values)
    results = BatchInvite.(UserInviter, invite_list, current_user, flag)
    render :json => results.to_json
  end

end
