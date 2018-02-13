module RequestsHelper

  def send_email_to_superadmin_about_request_for_admin_of org
    superadmin_emails = User.superadmins.pluck(:email)
    AdminMailer.new_user_waiting_for_approval(org.name, superadmin_emails).deliver_now
  end

end