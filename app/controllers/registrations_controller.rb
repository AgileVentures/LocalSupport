class RegistrationsController < Devise::RegistrationsController
  def create
    if params[:user]
      session[:pending_organisation_id] = params[:user][:pending_organisation_id]
    end
    super
  end

  def update_message_for_admin_status
    org = Organisation.find(params[:user][:pending_organisation_id])
    flash[:notice] << " You have requested admin status for #{org.name}"
    send_email_to_superadmin_about_request_for_admin_of org
  end

  protected
    def after_inactive_sign_up_path_for(resource)
      if session[:pending_organisation_id]
        UserOrganisationClaimer.new(self, resource, resource).call(session[:pending_organisation_id])
        return organisation_path resource.pending_organisation_id 
      else
        send_email_to_superadmin_about_signup resource.email
      end
      root_path
    end

    def send_email_to_superadmin_about_request_for_admin_of org
      superadmin_emails = User.superadmins.pluck(:email)
      AdminMailer.new_user_waiting_for_approval(org.name, superadmin_emails).deliver
    end

    def send_email_to_superadmin_about_signup user_email
      superadmin_emails = User.superadmins.pluck(:email)
      AdminMailer.new_user_sign_up(user_email, superadmin_emails).deliver
    end

end
