# https://github.com/plataformatec/devise/wiki/How-To:-Use-custom-mailer

class CustomDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  # The default values for any email we send from CustomDeviseMailer.
  # Any value can be overridden on a per-email basis.
  default from: "support@harrowcn.org.uk",
          cc: "technical@harrowcn.org.uk",
          reply_to: "support@harrowcn.org.uk"

  # from devise_invitable-1.2.1/lib/devise_invitable/mailer.rb
  def invitation_instructions(record, token, opts={})
    opts[:cc] = 'technical@harrowcn.org.uk'
    opts[:subject] = 'Welcome to Harrow Community Network!'
    @mail_template = MailTemplate.find_by(name: 'Invitation instructions')
    super
  end

  def proposed_org_approved(org,email, usr)
    @org = org
    @resource = usr
    mail(subject: "Your organisation has been approved for inclusion in the Harrow Community Network!",
         to: [email])
  end

end
