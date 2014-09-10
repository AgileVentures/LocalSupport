class UsersController < ApplicationController

  def edit
    @user = User.find_by_id params[:id]
  end

  def update
    usr = User.find_by_id params[:id]
    UserOrganisationClaimer.new(self, usr, usr).call(params[:pending_organisation_id])
  end

  def update_message_for_admin_status
    org = Organisation.find(params[:pending_organisation_id])
    flash[:notice] = "You have requested admin status for #{org.name}"
    redirect_to organisation_path(params[:pending_organisation_id])
  end

end