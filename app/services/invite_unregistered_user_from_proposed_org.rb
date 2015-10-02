class InviteUnregisteredUserFromProposedOrg

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
      u.save!
    end
    CustomDeviseMailer.proposed_org_approved(@org, @email, usr).deliver_now
  end
end