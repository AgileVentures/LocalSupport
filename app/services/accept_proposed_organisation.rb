class AcceptProposedOrganisation
  class Response
    NOTIFICATION_SENT = "Notification sent"
    INVITATION_SENT = "Invitation sent"
    INVALID_EMAIL = "Invalid Email"
    NO_EMAIL = "No email"
    OTHER_ERROR = "Other Error"

    attr_reader   :status, :error_msg 
    attr_accessor :accepted_org, :not_accepted_org

    def initialize status, error_msg, accepted_organisation
      @status = status
      @error_msg = error_msg
      @accepted_org = accepted_organisation
      @not_accepted_org = nil
    end
  end
  
  class NotificationError < StandardError; end

  def initialize(proposed_org)
    @org = proposed_org
    @email = @org.email
  end

  def run
    accept_organisation
  rescue NotificationError
    rollback_changes_to_org
  end

  private
  
  def accept_organisation
    @org = @org.accept_proposal
    @result = inform_user
    raise NotificationError unless success?(@result.status)
    @result                    
  end
  
  def inform_user
    @usr = User.find_by(email: @email)
    return notify_registered_usr if @usr
    rslt = InviteUnregisteredUserFromProposedOrg.new(@email, @org).run
    create_invitation_response_object(rslt)
  end
  
  def notify_registered_usr
    NotifyRegisteredUserFromProposedOrg.new(@usr, @org).run
    Response.new(Response::NOTIFICATION_SENT, nil, @org)
  end
  
  def rollback_changes_to_org
    @org = @org.rollback_acceptance
    @usr.organisation = nil if @usr
    @result.not_accepted_org = @result.accepted_org
    @result.accepted_org = nil
    @result
  end
  
  def success? status
    return true if [Response::NOTIFICATION_SENT, 
                    Response::INVITATION_SENT].include?(status)
    false
  end

  def create_invitation_response_object invitation_rslt
    return Response.new(Response::INVITATION_SENT, invitation_rslt.error_msg, @org) if invitation_rslt.success?
    case invitation_rslt.status
      when InviteUnregisteredUserFromProposedOrg::Response::INVALID_EMAIL
        Response.new(Response::INVALID_EMAIL, invitation_rslt.error_msg, @org)
      when InviteUnregisteredUserFromProposedOrg::Response::NO_EMAIL
        Response.new(Response::NO_EMAIL, invitation_rslt.error_msg, @org)
      else
        Response.new(Response::OTHER_ERROR, invitation_rslt.error_msg, @org)
    end
  end
end
