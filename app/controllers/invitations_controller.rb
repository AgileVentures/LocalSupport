class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only
  def create
    Devise.resend_invitation = to_boolean(params[:resend_invitation])
    job = BatchInvite.new(User, Organization, :organization_id=, current_user)
    status = job.run(params[:values])
    respond_to do |format|
      format.json { render :json => status.to_json }
    end
  end

  private

  def to_boolean(flag)
    return true if flag == 'true'
    return false if flag == 'false'
    raise "cannot cast '#{flag}' to boolean"
  end
end
