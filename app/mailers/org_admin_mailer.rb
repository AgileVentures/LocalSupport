class OrgAdminMailer < ActionMailer::Base

  # The default values for any email we send from OrgAdminMailer.
  # Any value can be overridden on a per-email basis.
  default from: "support@harrowcn.org.uk",
          cc: "technical@harrowcn.org.uk",
          reply_to: "support@harrowcn.org.uk"

  def new_org_admin(org, emails)
    @org = org
    mail(subject: "You have been made an organisation administrator on the Harrow Community Network",
         to: emails)
  end

  def notify_proposed_org_accepted(org, email)
    @org = org
    mail(subject:"Your Organisation has been accepted for inclusion on the Harrow Community Network",
         to: [email])
  end

end
