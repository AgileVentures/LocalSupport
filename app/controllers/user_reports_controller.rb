class UserReportsController < ApplicationController
  layout 'full_width', :except => [:invited]
  before_filter :authorize, :except => [:update]
  include ActionView::Helpers::DateHelper

  def deleted
    authorize :user_report, :access?
    @users = User.only_deleted
  end

  def undo_delete
    authorize :user_report, :access?
    usr = User.with_deleted.find_by_id params[:id]
    User.restore(params[:id])
    @users = User.only_deleted
    flash[:success] = "You have restored #{usr.email}"
    redirect_to(deleted_users_report_path)
  end

  # would like this to support generic updating of model with
  # business logic pulled into a separate model or process

  #TODO ask for explanation
  def update
    user = User.find_by_id(params[:id])
    if params[:pending_org_action] == "decline"
      UserOrganisationDecliner.new(self, user, current_user).call
    elsif params[:pending_org_action] == "approve"
      UserOrganisationClaimer.new(self, user, current_user).call(params[:organisation_id])
    end
  end

  def destroy
    authorize :user_report, :access?
    user = User.find(params[:id])
    if user == current_user
      flash[:error] = "You may not destroy your own account!"
    else
      user.destroy
      flash[:success] = "You have deleted #{user.email}."
    end
    redirect_to(users_report_path)
  end

  def index
    authorize :user_report, :access?
    @users = User.all
  end

  def invited
    authorize :user_report, :access?
    @resend_invitation = true
    @invitations = serialize_invitations
    @mail_template = MailTemplate.find_by(name: 'Invitation instructions')
    render :template => 'user_reports/invited', :layout => 'invitation_table'
  end

  def update_message_promoting(user)
    authorize :user_report, :access?
    flash[:notice] = "You have approved #{user.email}."
    redirect_to(users_report_path)
  end

  def authorization_failure_for_update
    authorize :user_report, :access?
    flash[:error] = t('authorize.superadmin')
    redirect_to(root_path)
  end

  def update_failure
    authorize :user_report, :access?
    redirect_to :status => 404
  end

  def update_message_for_decline_success(user, pending_organisation)
    authorize :user_report, :access?
    flash[:success] = "You have declined #{user.email}'s request for admin status for #{pending_organisation.name}."
    redirect_to(users_report_path)
  end

  private

  def serialize_invitations

    User.invited_not_accepted.select do |user|
      user.organisation.present? # because invitation data may be 'dirty'
    end.map do |user|
      {
          id: user.organisation.id,
          name: user.organisation.name,
          email: user.email,
          date: user.invitation_sent_at
      }
    end

  end
end
