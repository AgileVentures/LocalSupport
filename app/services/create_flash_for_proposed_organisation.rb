class CreateFlashForProposedOrganisation
  class Accepted
    def self.results
      { invited: AcceptProposedOrganisation::Response::INVITATION_SENT,
        notified: AcceptProposedOrganisation::Response::NOTIFICATION_SENT }
    end
  end
  
  class NotAccepted
    def self.results
      { invalid_email: AcceptProposedOrganisation::Response::INVALID_EMAIL,
        no_email: AcceptProposedOrganisation::Response::NO_EMAIL }
    end
  end
  
  def initialize obj
    @obj = obj
    @rslt = {}
  end
  
  def accepted?
    return true if [ Accepted.results[:invited], 
                     Accepted.results[:notified] ].include?(@obj.status)
    false
  end
  
  def flashes_for_accepted_org
    @rslt[:notice] = ['You have approved the following organisation']
    if_invitation_sent; if_notification_sent
    @rslt
  end
  
  def flash_for_not_accepted_org
    @rslt[:error] = "No mail was sent because: #{@obj.error_message}"
    if_invalid_email; if_no_email
    @rslt
  end
  
  def if_invalid_email
    @rslt[:error] = "No invitation email was sent because the email associated \
    with #{@obj.not_accepted_org.name}, #{@obj.not_accepted_org.email}, \
    seems invalid" if @obj.status == NotAccepted.results[:invalid_email]
  end
  
  def if_invitation_sent
    @rslt[:notice] << "An invitation email was sent to \
    #{@obj.accepted_org.email}" if @obj.status == Accepted.results[:invited]
  end
  
  def if_no_email
    @rslt[:error] = "No invitation email was sent \
    because no email is associated with the \
    organisation" if @obj.status == NotAccepted.results[:no_email]
  end
  
  def if_notification_sent
    @rslt[:notice] << "A notification of acceptance was sent to \
    #{@obj.accepted_org.email}" if @obj.status == Accepted.results[:notified]
  end
  
  def run
    return flashes_for_accepted_org if accepted?
    flash_for_not_accepted_org
  end
end