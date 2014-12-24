class UserReportsController < ApplicationController
  layout 'full_width', :except => [:invited]
  before_filter :authorize, :except => [:update]
  include ActionView::Helpers::DateHelper

  def deleted
    @users = User.only_deleted
  end

  def undo_delete
    usr = User.with_deleted.find_by_id params[:id]
    User.restore(params[:id])
    @users = User.only_deleted
    flash[:success] = "You have restored #{usr.email}"
    redirect_to(deleted_users_report_path)
  end

  # would like this to support generic updating of model with
  # business logic pulled into a separate model or process
  def update
    user = User.find_by_id(params[:id])
    UserOrganisationClaimer.new(self, user, current_user).call(params[:organisation_id])
  end

  def destroy
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
    @users = User.all
  end

  def invited
    @resend_invitation = true
    @invitations = serialize_invitations
    render :template => 'user_reports/invited', :layout => 'invitation_table'
  end

  def update_message_for_admin_status
    org = Organisation.find(params[:organisation_id])
    flash[:notice] = "You have requested admin status for #{org.name}"
    redirect_to(organisation_path(params[:organisation_id]))
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
