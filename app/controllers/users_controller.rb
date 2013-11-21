class UsersController < ApplicationController
  def update
    user = User.find_by_id(params[:id])
    if  params[:organization_id]
      user.pending_organization_id = params[:organization_id]
      user.save!
      flash[:notice] = "You have requested admin status for My Organization"
      redirect_to(organization_path(params[:organization_id]))
    else
      user.promote_to_org_admin #unless !current_user.admin?
      redirect_to(users_path)
    end
  end

  def index
    if !current_user.admin?
      #flash[:notice] = "You must be signed in as an admin to perform this action!"
      redirect_to root_path
      flash[:notice] = "You must be signed in as an admin to perform this action!"
    else
      @users = User.all
    end
  end
end
