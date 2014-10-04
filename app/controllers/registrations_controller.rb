class RegistrationsController < Devise::RegistrationsController
  def create
    if params[:user]
      session[:pending_organisation_id] = params[:user][:pending_organisation_id]
    end
    super
  end
  protected
    def after_inactive_sign_up_path_for(resource)
      if resource.pending_organisation
        update_message_for_admin_status
        return organisation_path resource.pending_organisation_id 
      else
        admin_emails = User.admins.pluck(:email)
        AdminMailer.new_user_waiting_for_approval(resource.email, admin_emails).deliver
      end
      root_path
    end
    def update_message_for_admin_status
      org = Organisation.find(params[:user][:pending_organisation_id])
      flash[:notice] << " You have requested admin status for #{org.name}"
    end
end
