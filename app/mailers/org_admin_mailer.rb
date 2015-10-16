class OrgAdminMailer < ActionMailer::Base

  def new_org_admin(org, emails)
    @org = org
    mail(subject: "You have been made an organisation administrator on the Harrow Community Network",
      to: emails ,
      from: "support@harrowcn.org.uk",
      cc: "technical@harrowcn.org.uk",
      reply_to: "support@harrowcn.org.uk")
  end

  def notify_proposed_org_accepted(org, email)
    @org = org
    mail(subject:"Your Organisation has been accepted for inclusion on the Harrow Community Network",
         to: [email],
         from:"support@harrowcn.org.uk",
         cc: "technical@harrowcn.org.uk",
         reply_to:"support@harrowcn.org.uk")
  end

end


