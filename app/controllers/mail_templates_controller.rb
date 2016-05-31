class MailTemplatesController < ApplicationController
  before_action :authorize
  
  def edit
    @mail_template = MailTemplate.find_by(name: 'Invitation instructions')
    @orphans = Organisation.not_null_email.null_users.without_matching_user_emails
    render :template => 'organisation_reports/without_users_edit', :layout => 'invitation_table'
  end
  
  def update
    @mail_template = MailTemplate.find(params[:id])
    @orphans = Organisation.not_null_email.null_users.without_matching_user_emails
    if @mail_template.update_attributes(mail_params)
      flash[:notice] = "Mail template has been updated"
      redirect_to organisations_report_path
    else
      redirect_to :back
    end
  end
  
  private
  
  def mail_params
    params.require(:mail_template).permit(:body, :footnote)
  end
end