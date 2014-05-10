class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only
  def create
    job = BatchInvite.new(params[:resend_invitation])
    status = job.run(current_user, params[:values])
    respond_to do |format|
      format.json { render :json => status.to_json }
    end
  end

end
