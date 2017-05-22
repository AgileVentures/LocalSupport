class RegistrationsController < Devise::RegistrationsController
  def create
    if params[:user]
      session[:proposed_org] = params[:user][:proposed_org]
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
        return organisation_path resource.pending_organisation 
      elsif session[:proposed_org]
        session[:user_id] =  resource.id
        return new_proposed_organisation_path
      else
        send_email_to_superadmin_about_signup resource.email
      end
      root_path
    end

    def send_email_to_superadmin_about_request_for_admin_of org
      superadmin_emails = User.superadmins.pluck(:email)
      AdminMailer.new_user_waiting_for_approval(org.name, superadmin_emails).deliver_now
    end

    def send_email_to_superadmin_about_signup user_email
      superadmin_emails = User.superadmins.pluck(:email)
      AdminMailer.new_user_sign_up(user_email, superadmin_emails).deliver_now
    end

end
