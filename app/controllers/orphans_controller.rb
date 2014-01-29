class OrphansController < ApplicationController
  layout 'full_width'
  before_filter :authorize

  def index
    @families = Organization.not_null_email.null_users.map {|org| session[org.id].present? ? [org, session[org.id]] : [org, ''] }
    @families += Organization.not_null_email.generated_users.map {|org| [org, org.users.first.reset_password_token]}
  end

  def create
    user = Organization.find_by_id(params[:id]).generate_potential_user
    if user.errors.any?
      response = user.errors.full_messages.first
    else
      response = user.reset_password_token
    end
    respond_to do |format|
      format.html { session[params[:id]] = response; redirect_to :index }
      format.json { render :json => response.to_json }
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