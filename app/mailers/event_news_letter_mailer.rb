class EventNewsLetterMailer < ApplicationMailer
  default from: "support@harrowcn.org.uk",
          cc: "technical@harrowcn.org.uk",
          reply_to: "support@harrowcn.org.uk"

  def monthly_newsletter(user, event)
    @user = user
    @event = event
    mail to: user.email, subject: 'Upcoming events updates'
  end
end
