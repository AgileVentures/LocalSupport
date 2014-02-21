class UserOrganizationClaimer 

  def initialize(listener, user, current_user)
    @listener = listener
    @user = user
    @current_user = current_user
  end

  def call(organization_id)
    if organization_id
      user.pending_organization_id = organization_id
      user.save!
      listener.update_message_for_admin_status
    elsif current_user.admin?
      user.promote_to_org_admin
      listener.update_message_promoting(user)
    else 
      listener.update_failure
    end
  end

  private
  attr_reader :listener, :user, :current_user
end
