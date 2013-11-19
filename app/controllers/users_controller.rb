class UsersController < ApplicationController
  def update
    user = User.find_by_id(params[:id])
    user.pending_organization_id = params[:organization_id]
    user.save!
    flash[:notice] = "You have requested admin status for My Organization"
    redirect_to(organization_path(params[:organization_id]))
  end

  def index
    @users = User.all
  end
end
