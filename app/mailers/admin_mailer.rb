class AdminMailer < ActionMailer::Base

  # The default values for any email we send from AdminMailer.
  # Any value can be overridden on a per-email basis.
  default from: 'support@harrowcn.org.uk',
          cc: 'technical@harrowcn.org.uk',
          reply_to: 'support@harrowcn.org.uk'

  def new_user_waiting_for_approval(org_name, superadmin_emails)
    @org_name = org_name
    s = "There is a user waiting for Admin approval to '#{org_name}'."
    mail(subject: s, to: superadmin_emails)
  end

  def new_user_sign_up(user_email, superadmin_emails)
    @user_email = user_email
    s = "A new user has joined #{Setting.site_title}"
    mail(subject: s,to: superadmin_emails)
  end

  def new_org_waiting_for_approval(org, superadmin_emails)
    @org = org
    s = "A new organisation has been proposed for inclusion in #{Setting.site_title}"
    mail(subject: s, to: superadmin_emails)
  end

  def edit_org_waiting_for_approval(org, superadmin_emails)
    @org = org
    s = "An edit to '#{org.name}' is awaiting Admin approval."
    mail(subject: s, to: superadmin_emails)
  end
end
