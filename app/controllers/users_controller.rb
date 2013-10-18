class UsersController < ApplicationController
  def index
    if current_user.blank?
      redirect_to user_session_path, alert: "You must be signed in as admin to perform that action!"
    elsif current_user.admin?
      if params[:charity_admin_pending] == "true"
        @users = User.find_all_by_charity_admin_pending(true)
      else
        @users = User.all
      end
    else
      redirect_to root_url, alert: "You must be signed in as admin to perform that action!"
    end
  end
end
