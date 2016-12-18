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

  def initialize(proposed_org)
    @proposed_org = proposed_org
    @email = @proposed_org.email
  end

  def run
    begin
      accept_organization
    rescue Exception
      @proposed_org.accept_proposal(true)
      @usr.organisation = nil if @usr
      @result.not_accepted_org = @result.accepted_org
      @result.accepted_org = nil
    end
    @result
  end

  private
  
  def accept_organization
    org = @proposed_org.accept_proposal
    @result = inform_user org
    raise Exception if [Response::NOTIFICATION_SENT, 
                        Response::INVITATION_SENT].include?(@result.status) == false 
  end
  
  def inform_user org
    @usr = User.find_by(email: @email)
    if @usr
      NotifyRegisteredUserFromProposedOrg.new(@usr,org).run
      Response.new(Response::NOTIFICATION_SENT, nil, org)
    else
      create_invitation_response_object(InviteUnregisteredUserFromProposedOrg.new(@email, org).run, org)
    end
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
