class AdminMailer < ActionMailer::Base

  # The default values for any email we send from AdminMailer.
  # Any value can be overridden on a per-email basis.
  default from: "support@harrowcn.org.uk",
          cc: "technical@harrowcn.org.uk",
          reply_to: "support@harrowcn.org.uk"

  def new_user_waiting_for_approval(org_name, superadmin_emails)
    @org_name = org_name
    mail(subject: "There is a user waiting for Admin approval to '#{org_name}'.",
         to: superadmin_emails)
  end

  def new_user_sign_up(user_email, superadmin_emails)
    @user_email = user_email
    mail(subject: "A new user has joined Harrow Community Network",
         to: superadmin_emails)
  end

  def new_org_waiting_for_approval(org, superadmin_emails)
    @org = org
    mail(subject: "A new organisation has been proposed for inclusion in Harrow Community Network",
         to: superadmin_emails)
  end

  def edit_org_waiting_for_approval(org, superadmin_emails)
    @org = org
    mail(subject: "An edit to '#{org.name}' is awaiting Admin approval.",
         to: superadmin_emails)
  end

end
