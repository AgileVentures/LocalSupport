class CreateFlashForProposedOrganisation
  ACCEPTED = {
    invited: AcceptProposedOrganisation::Response::INVITATION_SENT,
    notified: AcceptProposedOrganisation::Response::NOTIFICATION_SENT
  }.freeze
  
  NOT_ACCEPTED = {
    invalid_email: AcceptProposedOrganisation::Response::INVALID_EMAIL,
    no_email: AcceptProposedOrganisation::Response::NO_EMAIL
  }.freeze
  
  def initialize obj
    @obj = obj
    @rsl = {}
  end
  
  def accepted?
    return true if [ ACCEPTED[:invited], 
                     ACCEPTED[:notified] ].include?(@obj.status)
    false
  end
  
  def flashes_for_accepted_org
    @rsl[:notice] = ['You have approved the following organisation']
    if_invitation_or_notification_sent
    @rsl
  end
  
  def flash_for_not_accepted_org
    @rsl[:error] = "No mail was sent because: #{@obj.error_message}"
    if_invalid_email; if_no_email
    @rsl
  end
  
  def if_invalid_email
    @rsl[:error] = 'No invitation email was sent because the email ' \
                   "associated with #{@obj.not_accepted_org.name}," \
                   " #{@obj.not_accepted_org.email}, seems" \
                   ' invalid' if @obj.status == NOT_ACCEPTED[:invalid_email]
  end
  
  def if_invitation_or_notification_sent
    email_type = sent_email_type
    @rsl[:notice] << "#{email_type} was sent to " \
                     "#{@obj.accepted_org.email}" unless email_type.empty?
  end
  
  def if_no_email
    @rsl[:error] = 'No invitation email was sent' \
                   ' because no email is associated with the' \
                   ' organisation' if @obj.status == NOT_ACCEPTED[:no_email]
  end

  def run
    return flashes_for_accepted_org if accepted?
    flash_for_not_accepted_org
  end
  
  def sent_email_type
    return 'A notification of acceptance' if @obj.status == ACCEPTED[:notified]
    return 'An invitation email' if @obj.status == ACCEPTED[:invited]
    ''
  end
end