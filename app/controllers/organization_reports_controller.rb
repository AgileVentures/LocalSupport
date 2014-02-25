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
      if user.present?
        user.errors.add(:email, 'has already been taken')
      else
        user = User.invite!({email: value[:email]}, current_user)
      end
      msg = user.errors.any? ? 'Error: ' + user.errors.full_messages.first : 'Invited!'
      response[value[:id]] = msg
      response
    end
    respond_to do |format|
      format.json { render :json => res.to_json }
    end
  end
end