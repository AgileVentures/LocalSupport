class OrganisationReportsController < ApplicationController
  layout 'full_width', :except => [:without_users_index]
  before_filter :authorize

  def without_users_index
    @resend_invitation = false
    @mail_template = MailTemplate.find_by(name: 'Invitation instructions')
    @orphans = Organisation.not_null_email.null_users.without_matching_user_emails
    render :template => 'organisation_reports/without_users_index', :layout => 'invitation_table'
  end
end
