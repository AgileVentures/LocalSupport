class ApplicationController < ActionController::Base
  protect_from_forgery
  def after_sign_in_path_for (resource)
    if session[:organization_id]
      flash[:notice] = "You have requested admin status for My Organization"
      current_user.set_charity_admin_status_pending(session[:organization_id])
    end
    return root_url if current_user.admin? || current_user.organization == nil
    organization_path(current_user.organization.id)
  end
end
