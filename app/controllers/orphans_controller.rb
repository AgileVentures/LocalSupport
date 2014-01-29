class OrphansController < ApplicationController
  layout 'full_width'
  before_filter :authorize

  def index
    @families = Organization.not_null_email.null_users + Organization.not_null_email.generated_users
    @families = @families.map do |org|
      if params[:id].to_i == org.id
        user = Organization.find_by_id(params[:id]).generate_potential_user
      else
        user = org.users.present? ? org.users.first : NullObject.new
      end
      [org, user]
    end
  end

  def orphans_remote
    @user = Organization.find_by_id(params[:id]).generate_potential_user
    if @user.errors.any?
      @user = @user.errors.full_messages.first
    else
      @user = @user.reset_password_token
    end
    respond_to do |format|
      format.json { render :json => @user.to_json }
    end
  end

  #def parents
  # result = Organization.find_by_id(params[:id]).generate_potential_user
  # @result = result.errors ? user.errors.full_messages.first : user.reset_password_token
  #end
end