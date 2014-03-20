class CustomDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def send_devise_notification(notification, opts={})
    opts[:cc] = "technical@harrowcn.org.uk"
    super
  end
end