class InvitationsController < ApplicationController
  before_filter :authorize

  # xhr only, tested in a request spec
  def create
    res = params[:values].each_with_object({}) do |value, response|
      response[value[:id]] = invite_user(value[:email], params[:resend_invitation], value[:id])
    end
    respond_to do |format|
      format.json { render :json => res.to_json }
    end
  end

  private
  def invite_user(email, resend_invitation, organization_id)
    UserInviter.new(User, current_user, Devise).invite(
        email, resend_invitation, organization_id)
  end
end
