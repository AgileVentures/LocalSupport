class OrganizationReportsController < ApplicationController
  layout 'full_width'
  before_filter :authorize
  include OrganizationReportsHelper

  def without_users_index
    @orphans = Organization.not_null_email.null_users
    @orphans += Organization.not_null_email.generated_users
  end

  # http://stackoverflow.com/questions/5315465/rails-3-link-to-generator-for-post-put-delete
  # since graceful degradation is impossible anyway, js-disabled users can suck it
  def without_users_create
    user = Organization.find_by_id(params[:id]).generate_potential_user
    msg = user.errors.any? ? user.errors.full_messages.first : retrieve_password_url(user.reset_password_token)
    respond_to do |format|
      format.json { render :json => msg.to_json }
    end
  end
end