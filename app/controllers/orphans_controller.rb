class OrphansController < ApplicationController
  layout 'full_width'
  before_filter :authorize

  def index
    @orphans = Organization.not_null_email.null_users.map
    @robo_matched = Organization.not_null_email.generated_users
  end

  # json only, js-disabled users can suck it
  # http://stackoverflow.com/questions/5315465/rails-3-link-to-generator-for-post-put-delete
  def create
    user = Organization.find_by_id(params[:id]).generate_potential_user
    debugger
    if user.errors.any?
      msg = user.errors.full_messages.first
    else
      msg = user.reset_password_token
    end
    respond_to do |format|
      format.json { render :json => msg.to_json }
    end
  end


  #def orphans_remote
  #  @user = Organization.find_by_id(params[:id]).generate_potential_user
  #  if @user.errors.any?
  #    @user = @user.errors.full_messages.first
  #  else
  #    @user = @user.reset_password_token
  #  end
  #  respond_to do |format|
  #    format.json { render :json => @user.to_json }
  #  end
  #end

  #def parents
  # result = Organization.find_by_id(params[:id]).generate_potential_user
  # @result = result.errors ? user.errors.full_messages.first : user.reset_password_token
  #end
end