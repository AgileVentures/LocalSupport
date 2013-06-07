class ApplicationController < ActionController::Base
  protect_from_forgery
  def after_sign_in_path_for (resource)
     return new_organization_path
  end

end
