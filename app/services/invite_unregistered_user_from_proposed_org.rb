class InviteUnregisteredUserFromProposedOrg

  class Response
    INVALID_EMAIL = "Invalid Email"
    NO_EMAIL = "No Email"
    OTHER_FAILURE = "Other Failure"
    SUCCESS = "Success"

    attr_reader :status, :error_message

    def initialize(status, error_msg)
      @status = status
      @error_message = error_msg
    end

    def success?
      @status == SUCCESS
    end
  end

  def initialize(email, org)
    @email = email
    @org = org
  end

  def run
    #for the future this from the devis wiki might be relevant
    #When skip_invitation is used, you must also then set the invitation_sent_at field when the user is sent
    # their token. Failure to do so will yield “Invalid invitation token” errors when the user attempts to
    # accept the invite. You can set it like so:
    # user.deliver_invitation
    #but this seems not to be necessary right now per acceptance tests
    usr = User.invite!(:email => @email) do |u|
      u.skip_invitation = true
      u.skip_confirmation!
      u.organisation = @org
    end
    if usr.valid?
      CustomDeviseMailer.proposed_org_approved(@org, @email, usr).deliver_now
    end
    create_response_object(usr)
  end

  private

  def create_response_object(usr)
    return Response.new(Response::SUCCESS, nil) if usr.errors.empty?
    status =  case usr.errors.full_messages.first
      when "Email can't be blank"
        Response::NO_EMAIL
      when "Email is invalid"
        Response::INVALID_EMAIL
      else
        Response::OTHER_FAILURE
    end
    return Response.new(status,usr.errors.full_messages.first)
  end


end
