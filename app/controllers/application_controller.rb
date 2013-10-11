class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/users/sign_in" &&
      request.fullpath != "/users/sign_up" &&
      request.fullpath != "/users/password" &&
      !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end
  
  def after_sign_in_path_for(resource)
    if current_user.organization_id.present?
      return organization_path(current_user.organization.id)
    end
    if current_user.admin?
      return root_url 
    end
    session[:previous_url] || root_path
  end
end
