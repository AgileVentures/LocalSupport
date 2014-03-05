class OrganizationReportsController < ApplicationController
  layout 'full_width'
  before_filter :authorize

  def without_users_index
    @orphans = Organization.not_null_email.null_users
    @resend_invitation = false
  end

  # Uses email to create invite, uses id to respond with msg
  def without_users_create
    response = params[:values].reduce({}) do |response, value|
      response[value[:id]] = UserInviter.new(
        self, User, current_user, Devise
      ).invite(value[:email], params[:resend_invitation])
      response
    end
    respond_to do |format|
      format.json { render :json => response.to_json }
    end
  end
end
