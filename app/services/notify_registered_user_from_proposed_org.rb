class NotifyRegisteredUserFromProposedOrg
  def initialize(user,org)
    @user = user
    @org = org
  end
  def run
    @user.organisation = @org
    @user.save!
    OrgAdminMailer.notify_proposed_org_accepted(@org,@user.email).deliver_now
  end
end
