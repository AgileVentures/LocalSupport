class UsersController < ApplicationController
  def index
    if params[:charity_admin_pending] == "true"
      @users = User.find_all_by_charity_admin_pending(true)
    else
      @users = User.all
    end
  end
end
