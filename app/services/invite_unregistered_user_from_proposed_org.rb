class InviteUnregisteredUserFromProposedOrg

  def initialize(email, org)
    @email = email
    @org = org
  end

  def run
    User.invite!(:email => @email) do |u|
      u.skip_invitation = true
      u.skip_confirmation!
      u.organisation = @org
      u.save!
    end
    CustomDeviseMailer.proposed_org_approved(@org, @email).deliver_now
  end
end