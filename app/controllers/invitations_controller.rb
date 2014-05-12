class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only
  def create
    Devise.resend_invitation = to_boolean(params.fetch(:resend_invitation))
    job = BatchInvite.new(User, Organization, :organization_id=, current_user)
    status = job.run(params.fetch(:values))
    respond_to do |format|
      format.json { render :json => status.to_json }
    end
  end

  private

  def to_boolean(flag)
    return true if flag.to_s == 'true'
    return false if flag.to_s == 'false'
    raise "cannot cast #{flag.class} '#{flag}' to boolean"
  end
end
