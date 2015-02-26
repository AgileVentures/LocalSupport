class UserOrganisationClaimer 

  def initialize(listener, user, current_user)
    @listener = listener
    @user = user
    @current_user = current_user
  end

  def call(organisation_id)
    request_admin_status_if(organisation_id)
    error_message_if_not_superadmin_or_not(organisation_id)
    promote_user_if_superadmin_and_not(organisation_id)
  end

  private
  attr_reader :listener, :user, :current_user

  def is_current_user_superadmin?
    current_user.superadmin?
  end

  def request_admin_status_if(organisation_id)
    if organisation_id 
      user.request_admin_status organisation_id
      listener.update_message_for_admin_status
    end
  end

  def error_message_if_not_superadmin_or_not(organisation_id)
    if !is_current_user_superadmin? && !organisation_id
      listener.update_failure
    end
  end

  def promote_user_if_superadmin_and_not(organisation_id)
    if is_current_user_superadmin? && !organisation_id
      user.promote_to_org_admin
      listener.update_message_promoting(user)
    end
  end
end
