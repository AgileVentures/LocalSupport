class UsersController < ApplicationController

  def edit
    @user = User.find_by_id params[:id]
  end

  # we should allow logged in users to update their pending_organisation_id
  # and only admins should be allowed to update organisation_id
  # makes me think of a attributes permissions matrix
  def update
    usr = User.find_by_id params[:id]
    UserOrganisationClaimer.new(self, usr, usr).call(params[:pending_organisation_id])
  end

  def update_message_for_admin_status
    org = Organisation.find(params[:pending_organisation_id])
    flash[:notice] = "You have requested admin status for #{org.name}"
    send_email_to_site_admin_about_request_for_admin_of org   # could be moved to an hook on the user model?
    redirect_to organisation_path(params[:pending_organisation_id])
  end

  def send_email_to_site_admin_about_request_for_admin_of org
    admin_emails = User.admins.pluck(:email)
    AdminMailer.new_user_waiting_for_approval(org.name, admin_emails).deliver
  end

end