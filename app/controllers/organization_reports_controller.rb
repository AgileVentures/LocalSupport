class OrganizationReportsController < ApplicationController
  layout 'full_width'
  before_filter :authorize
  respond_to :json

  def without_users_index
    @orphans = Organization.not_null_email.null_users
    @resend_invitation = false
  end

  # Uses email to create invite, uses id to respond with msg
  def without_users_create
    response = params[:values].each_with_object({}) do |value, response|
      response[value[:id]] = UserInviter.new(
        self, User, current_user, Devise
      ).invite(value[:email], params[:resend_invitation])
    end
    respond_with response.to_json
  end
end
