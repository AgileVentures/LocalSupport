class AcceptProposedOrganisation
  def initialize(proposed_org)
    @proposed_org = proposed_org
    @email = @proposed_org.email
  end

  def run
    org = @proposed_org.accept_proposal
    usr = User.find_by(email: @email)
    if usr
      NotifyRegisteredUserFromProposedOrg.new(usr,org).run
    else
      result_of_inviting = InviteUnregisteredUserFromProposedOrg.new(@email,org).run
    end
  end
end
