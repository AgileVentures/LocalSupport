class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only
  def create
    flag = params.fetch(:resend_invitation)
    invite_list = params.fetch(:values)
    response = BatchInvite.(UserInviter, invite_list, current_user, flag)
    debugger
    respond_to do |format|
      format.json { render :json => response.to_json }
    end
  end

end
