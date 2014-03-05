class OrganizationReportsController < ApplicationController
  layout 'full_width'
  before_filter :authorize

  def without_users_index
    @orphans = Organization.not_null_email.null_users
    @resend_invitation = false
  end

  # Uses email to create invite, uses id to respond with msg
  def without_users_create
    response = params[:values].each_with_object({}) do |value, response|
      response[value[:id]] = invite_user(value[:email], params[:resend_invitation])
    end
    respond_to do |format|
      format.json { render :json => response.to_json }
    end
  end

  private 
  def invite_user(email, resend_invitation)
    UserInviter.new(self, User, current_user, Devise).invite(
      email, resend_invitation)
  end
end
