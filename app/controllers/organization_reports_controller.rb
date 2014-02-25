class OrganizationReportsController < ApplicationController
  layout 'full_width'
  before_filter :authorize

  def without_users_index
    @orphans = Organization.not_null_email.null_users
  end

  # Uses email to create invite, uses id to respond with msg
  def without_users_create
    res = params[:values].reduce({}) do |response, value|
      user = User.find_by_email(value[:email])
      UserInviter.new(
        self, User, current_user
      ).invite(
         value[:email], user, value[:id]
      )
    end
    respond_to do |format|
      format.json { render :json => res.to_json }
    end
  end

  def build_response(msg, dom_id)
    response[dom_id] = msg
    response
  end
end
