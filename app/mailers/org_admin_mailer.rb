class OrgAdminMailer < ActionMailer::Base

  # The default values for any email we send from OrgAdminMailer.
  # Any value can be overridden on a per-email basis.
  default from: 'support@harrowcn.org.uk',
          cc: 'technical@harrowcn.org.uk',
          reply_to: 'support@harrowcn.org.uk'

  def new_org_admin(org, emails)
    @org = org
    s = "You have been made an organisation administrator on the #{Setting.site_title}"
    mail(subject: s, to: emails)
  end

  def notify_proposed_org_accepted(org, email)
    @org = org
    s = "Your Organisation has been accepted for inclusion on the #{Setting.site_title}"
    mail(subject: s, to: [email])
  end

end
