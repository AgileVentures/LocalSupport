class CookiePolicyController < ApplicationController
  def allow
    response.set_cookie 'rack.policy', {
        value: 'true',
        path: '/',
        expires: 1.year.from_now.utc
    }
    redirect_to root_path
  end

  def deny
    response.delete_cookie 'rack.policy'
    redirect_to root_path
  end
end
