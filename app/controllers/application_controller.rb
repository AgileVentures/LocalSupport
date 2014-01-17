class ApplicationController < ActionController::Base
  protect_from_forgery
  def after_sign_in_path_for (resource)
     return root_url if current_user.admin? || current_user.organization == nil
     organization_path(current_user.organization.id)
  end

  def allow_cookie_policy
    response.set_cookie 'cookie_policy_accepted', {
        value: 'true',
        path: '/',
        expires: 1.year.from_now.utc
    }
    respond_to do |format|
      format.html redirect_to root_path
      format.json { render :nothing => true, :status => 200 }
    end

    redirect_to root_path
  end
end
