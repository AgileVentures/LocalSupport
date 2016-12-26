class AcceptProposedOrganisation
  class Response
    NOTIFICATION_SENT = "Notification sent"
    INVITATION_SENT = "Invitation sent"
    INVALID_EMAIL = "Invalid Email"
    NO_EMAIL = "No email"
    OTHER_ERROR = "Other Error"

    attr_reader   :status, :error_message 
    attr_accessor :accepted_org, :not_accepted_org

    def initialize status, error_message, accepted_organisation
      @status = status
      @error_message = error_message
      @accepted_org = accepted_organisation
      @not_accepted_org = nil
    end
  end
  
  class NotificationError < StandardError; end

  def initialize(proposed_org)
    @proposed_org = proposed_org
    @email = @proposed_org.email
  end

  def run
    accept_organisation
  rescue NotificationError
    rollback_changes_to_org
  end

  private
  
  def accept_organisation
    org = @proposed_org.accept_proposal; @result = inform_user org
    raise NotificationError if success?(@result.status) == false
    @result                    
  end
  
  def inform_user org
    @usr = User.find_by(email: @email)
    return notify_registered_usr org if @usr
    rslt = InviteUnregisteredUserFromProposedOrg.new(@email, org).run
    create_invitation_response_object(rslt, org)
  end
  
  def notify_registered_usr org
    NotifyRegisteredUserFromProposedOrg.new(@usr,org).run
    Response.new(Response::NOTIFICATION_SENT, nil, org)
  end
  
  def rollback_changes_to_org
    @proposed_org.accept_proposal(true); @usr.organisation = nil if @usr
    @result.not_accepted_org = @result.accepted_org; @result.accepted_org = nil
    @result
  end
  
  def success? status
    return true if [Response::NOTIFICATION_SENT, 
                    Response::INVITATION_SENT].include?(status)
    false
  end

  def create_invitation_response_object(result_of_inviting, org)
    return Response.new(Response::INVITATION_SENT, result_of_inviting.error_message, org) if result_of_inviting.success?
    case result_of_inviting.status
      when InviteUnregisteredUserFromProposedOrg::Response::INVALID_EMAIL
        Response.new(Response::INVALID_EMAIL, result_of_inviting.error_message, org)
      when InviteUnregisteredUserFromProposedOrg::Response::NO_EMAIL
        Response.new(Response::NO_EMAIL, result_of_inviting.error_message, org)
      else
        Response.new(Response::OTHER_ERROR, result_of_inviting.error_message, org)
    end
  end
end
