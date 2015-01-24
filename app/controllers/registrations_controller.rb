class RegistrationsController < Devise::RegistrationsController
  def create
    if params[:user]
      session[:pending_organisation_id] = params[:user][:pending_organisation_id]
    end
    super
  end
  protected
    def after_inactive_sign_up_path_for(resource)
      if  session[:pending_organisation_id]
        resource.pending_organisation_id = session[:pending_organisation_id]
        resource.save!
        update_message_for_superadmin_status
        return organisation_path resource.pending_organisation_id 
      else
        send_email_to_site_superadmin_about_signup resource.email
      end
      root_path
    end
    def update_message_for_superadmin_status
      org = Organisation.find(params[:user][:pending_organisation_id])
      flash[:notice] << " You have requested superadmin status for #{org.name}"
    end
    def send_email_to_site_superadmin_about_signup user_email
      superadmin_emails = User.superadmins.pluck(:email)
      AdminMailer.new_user_sign_up(user_email, superadmin_emails).deliver
    end

end
