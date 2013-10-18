# Create a new class to pick up the custom plain-text templates only.
#
# AdminUser is not confirmable or lockable, so we need only define the
# recoverable mailer method.
#
# @see config/initializers/devise.rb
class AdminMailer < Devise::Mailer

  def new_user_waiting_for_approval(org)
    debugger
    @org_name = org.name
    @admins=User.find_all_by_admin(true)
    @admins.each do |admin|
      mail(to: admin.email)
      mail(from: config.mailer_sender)
      mail.deliver
    end
  end
end
