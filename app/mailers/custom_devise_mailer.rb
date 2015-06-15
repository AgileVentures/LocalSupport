# https://github.com/plataformatec/devise/wiki/How-To:-Use-custom-mailer

class CustomDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  # from devise_invitable-1.2.1/lib/devise_invitable/mailer.rb
  def invitation_instructions(record, token, opts={})
    opts[:cc] = 'technical@harrowcn.org.uk'
    opts[:subject] = 'Welcome to Harrow Community Network!'
    super
  end
end
