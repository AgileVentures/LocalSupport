class InviteUnregisteredUserFromProposedOrg

  def initialize(email, org)
    @email = email
    @org = org
  end

  def run
    CustomDeviseMailer.proposed_org_approved(@org, @email).deliver_now
  end
end