class ApplicationController < ActionController::Base
  protect_from_forgery
  def after_sign_in_path_for (resource)
     return root_url if current_charity_worker.admin? || current_charity_worker.organization == nil
     organization_path(current_charity_worker.organization.id)
  end
end
