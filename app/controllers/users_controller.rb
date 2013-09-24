class UsersController < ApplicationController
  def index
    if params[:charity_admin] == "false"
      @users = User.find_all_by_charity_admin(false)
    else
      @users = User.all
    end
  end
end
