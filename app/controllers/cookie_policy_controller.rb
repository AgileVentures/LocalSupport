class CookiePolicyController < ApplicationController
  def allow
    response.set_cookie 'rack.policy', {
        value: 'true',
        path: '/',
        expires: 1.year.from_now.utc
    }
    render nothing: true
  end

  def deny
    response.delete_cookie 'rack.policy'
    render nothing: true
  end
end
