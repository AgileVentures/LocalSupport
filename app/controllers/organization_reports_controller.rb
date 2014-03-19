class OrganizationReportsController < ApplicationController
  layout 'full_width'
  before_filter :authorize

  def without_users_index
    @orphans = Organization.not_null_email.null_users.without_matching_user_emails
    @resend_invitation = false
  end
end
