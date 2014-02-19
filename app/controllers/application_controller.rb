class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    unless (request_path_includes?(sign_in_url) ||
        request_path_includes?(sign_up_url) ||
        request_path_includes?(user_confirmation) ||
        request_path_includes?(sign_password) ||
        request_path_includes?(cookies_allow) ||
        request.xhr?) # don't store ajax calls
      session[:previous_url] = request.path
    end
  end

  #We test this functionality in sign-in tests for session_controller_spec
  def after_sign_in_path_for(resource)
    store_location
    return session[:previous_url] if session[:previous_url]
    return organization_path(current_user.organization) if current_user.organization
    root_path
  end

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

    redirect_to request.referer || '/'
  end

  private

  # http://railscasts.com/episodes/20-restricting-access
  def authorize
    unless admin?
      flash[:error] = 'You must be signed in as an admin to perform this action!'
      redirect_to '/'
      false
    end
  end

  # Not to be confused with the activerecord admin? method
  def admin?
    current_user.try :admin?
  end

  def sign_in_url
    Regexp.new '/users/sign_in'
  end

  def sign_up_url
    Regexp.new '/users/sign_up'
  end

  def sign_password
    Regexp.new '/users/password'
  end

  def user_confirmation
    Regexp.new '/users/confirmation'
  end

  def cookies_allow
    Regexp.new '/cookies/allow'
  end

  def request_path_includes?(url)
    url =~ request.path
  end
end
