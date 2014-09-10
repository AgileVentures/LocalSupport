class SessionsController < Devise::SessionsController

  def create
    session[:pending_organisation_id] = params[:pending_organisation_id]
    super
    #if params[:pending_organisation_id] && current_user
    #  UserOrganisationClaimer.new(self, current_user, current_user).call(params[:pending_organisation_id])
    #end
  end

  def update_message_for_admin_status
    org = Organisation.find(params[:pending_organisation_id])
    flash[:notice] = "You have requested admin status for #{org.name}"
  end
end
