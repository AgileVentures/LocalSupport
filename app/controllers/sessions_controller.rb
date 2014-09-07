class SessionsController < Devise::SessionsController

  def create
    session[:pending_organization_id] = params[:pending_organization_id]
    super
    if params[:pending_organization_id] && current_user
      UserOrganizationClaimer.new(self, current_user, current_user).call(params[:pending_organization_id])
    end
  end

  def update_message_for_admin_status
    org = Organization.find(params[:pending_organization_id])
    flash[:notice] = "You have requested admin status for #{org.name}"
  end
end
