class UsersController < ApplicationController
  layout 'full_width'
  before_filter :authorize, :except => [:update]

  # would like this to support generic updating of model with
  # business logic pulled into a separate model or process
  def update
    user = User.find_by_id(params[:id])
    UserOrganizationClaimer.new(self, user, current_user).call(params[:organization_id])
  end

  def index
    @users = User.all
  end

  def update_message_for_admin_status
    org = Organization.find(params[:organization_id])
    flash[:notice] = "You have requested admin status for #{org.name}"
    redirect_to(organization_path(params[:organization_id]))
  end

  def update_message_promoting(user)
    flash[:notice] = "You have approved #{user.email}."
    redirect_to(users_path)
  end

  def update_failure
    redirect_to :status => 404 
  end
end

class UserOrganizationClaimer 

  def initialize(listener, user, current_user)
    @listener = listener
    @user = user
    @current_user = current_user
  end

  def call(organization_id)
    if organization_id
      user.pending_organization_id = organization_id
      user.save!
      listener.update_message_for_admin_status
    elsif current_user.admin?
      user.promote_to_org_admin
      listener.update_message_promoting(user)
    else 
      listener.update_failure
    end
  end

  private
  attr_reader :listener, :user, :current_user
end
