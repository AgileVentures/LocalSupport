class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    unless (request.path == "/users/sign_in" ||
        request.path == "/users/sign_up" ||
        request.path == "/users/password" ||
        request.xhr?) # don't store ajax calls
      session[:previous_url] = request.path
    end
  end

  #We test this functionality in sign-in tests for session_controller_spec
  def after_sign_in_path_for(resource)
    store_location
    session[:previous_url] || root_path
  end

  #def after_sign_in_path_for (resource)
  #   return root_url if current_user.admin? || current_user.organization == nil
  #   organization_path(current_user.organization.id)
  #end

  def allow_cookie_policy
    response.set_cookie 'cookie_policy_accepted', {
        value: 'true',
        path: '/',
        expires: 1.year.from_now.utc
    }
    #respond_to do |format|
    #  format.html redirect_to root_path
    #  format.json { render :nothing => true, :status => 200 }
    #end

    redirect_to root_path
  end
end
