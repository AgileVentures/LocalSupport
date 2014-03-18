class UserOrganizationClaimer 

  def initialize(listener, user, current_user)
    @listener = listener
    @user = user
    @current_user = current_user
  end

  def call(organization_id)
    request_admin_status_if(organization_id)
    error_message_if_not_admin_or_not(organization_id)
    promote_user_if_admin_and_not(organization_id)
  end

  private
  attr_reader :listener, :user, :current_user

  def is_current_user_admin?
    current_user.admin?
  end

  def request_admin_status_if(organization_id)
    if organization_id 
      user.request_admin_status organization_id
      listener.update_message_for_admin_status
    end
  end

  def promote_user_if_admin_and_not(organization_id)
    if is_current_user_admin? && !organization_id
      user.promote_to_org_admin
      listener.update_message_promoting(user)
    end
  end

  def error_message_if_not_admin_or_not(organization_id)
    if !is_current_user_admin? && !organization_id
      listener.update_failure
    end
  end
end
