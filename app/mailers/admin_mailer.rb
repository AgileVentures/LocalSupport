class AdminMailer < ActionMailer::Base

  def new_user_waiting_for_approval(org_name, admin_emails)
    @org_name = org_name
    mail(subject: "There is a user waiting for Admin approval to '#{org_name}'.",
         to: admin_emails ,
         from: "support@harrowcn.org.uk",
         cc: "technical@harrowcn.org.uk",
         reply_to: "support@harrowcn.org.uk")
  end

  def new_user_sign_up(user_email, admin_emails)
    @user_email = user_email
    mail(subject: "A new user has joined Harrow Community Network",
         to: admin_emails ,
         from: "support@harrowcn.org.uk",
         cc: "technical@harrowcn.org.uk",
         reply_to: "support@harrowcn.org.uk")
  end
end
