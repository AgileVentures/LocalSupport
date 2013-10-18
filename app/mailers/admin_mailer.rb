# Create a new class to pick up the custom plain-text templates only.
#
# AdminUser is not confirmable or lockable, so we need only define the
# recoverable mailer method.
#
# @see config/initializers/devise.rb
class AdminMailer < Devise::Mailer
  default from: ENV['ACTION_MAILER_FROM']

  def reset_password_instructions(record)
    I18n.with_locale(record.locale) do
      initialize_from_record(record)

      @host = ActionMailer::Base.default_url_options[:host] || I18n.t('app.host')
      if record.organization
        questionnaire = record.organization.questionnaires.last
        if questionnaire && questionnaire.domain?
          @host = questionnaire.domain
        end
      end

      headers = headers_for(:reset_password_instructions)
      headers.merge! reply_to: ENV['ACTION_MAILER_REPLY_TO']
      headers.delete :template_path
      mail headers
    end
  end

  def new_user_waiting_for_approval(org)
    @org_name = org.name
    @admins=User.find_all_by_admin(true)
    @admins.each do |admin|
      mail(to: admin.email)
      mail.deliver
    end
  end
end
