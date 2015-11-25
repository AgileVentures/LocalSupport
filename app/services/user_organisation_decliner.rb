class UserOrganisationDecliner

  def initialize(listener, user, current_user)
    @listener = listener
    @user = user
    @current_user = current_user
  end

  def call
    error_message_if_not_superadmin
    remove_pending_org_from_user
  end

  private

  attr_reader :listener, :user, :current_user

  def error_message_if_not_superadmin
    listener.authorization_failure_for_update unless current_user.superadmin?
  end

  def remove_pending_org_from_user
    if current_user.superadmin?
      pending_org = user.pending_organisation
      user.update_attributes!(pending_organisation_id: nil)
      listener.update_message_for_decline_success(user, pending_org)
    end
  end

end
