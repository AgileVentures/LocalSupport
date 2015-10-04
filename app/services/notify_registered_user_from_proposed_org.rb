class NotifyRegisteredUserFromProposedOrg
  class Response
    def success?
      true
    end
  end
  def initialize(user,org)
    @user = user
    @org = org
  end
  def run
    @user.organisation = @org
    @user.save!
    OrgAdminMailer.notify_proposed_org_accepted(@org,@user.email).deliver_now
    Response.new
  end
end
