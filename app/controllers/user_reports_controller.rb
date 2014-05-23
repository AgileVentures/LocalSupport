class UserReportsController < ApplicationController
  layout 'full_width', :except => [:invited]
  before_filter :authorize, :except => [:update]
  include ActionView::Helpers::DateHelper


  # would like this to support generic updating of model with
  # business logic pulled into a separate model or process
  def update
    user = User.find_by_id(params[:id])
    UserOrganizationClaimer.new(self, user, current_user).call(params[:organization_id])
  end

  def index
    @users = User.all
  end

  def invited
    @resend_invitation = true
    @invitations = serialize_invitations
    render :template => 'user_reports/invited', :layout => 'invitation_table'
  end

  def update_message_for_admin_status
    org = Organization.find(params[:organization_id])
    flash[:notice] = "You have requested admin status for #{org.name}"
    redirect_to(organization_path(params[:organization_id]))
  end

  def update_message_promoting(user)
    flash[:notice] = "You have approved #{user.email}."
    redirect_to(users_report_path)
  end

  def update_failure
    redirect_to :status => 404
  end

  private

  def serialize_invitations

    User.invited_not_accepted.select do |user|
      user.organization.present? # because invitation data may be 'dirty'
    end.map do |user|
      {
          id: user.organization.id,
          name: user.organization.name,
          email: user.email,
          date: user.invitation_sent_at
      }
    end

  end
end
