class OrgAdminMailer < ActionMailer::Base

  def new_org_admin(org, emails)
    @org = org
    mail(subject: "You have been made an organisation administrator on the Harrow Community Network",
      to: emails ,
      from: "support@harrowcn.org.uk",
      cc: "technical@harrowcn.org.uk",
      reply_to: "support@harrowcn.org.uk")
  end

end


