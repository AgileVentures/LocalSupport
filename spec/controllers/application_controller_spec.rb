require 'spec_helper'

describe ApplicationController do
  #Note this is tested by the sessions_controller_spec in order to take advantage of routing/post methods etc.
  describe 'after_sign_in_path' do
  end

  describe 'allow_cookie_policy' do
    it 'cookie is set and redirected to root' do
      response.should_receive(:set_cookie)
      get :allow_cookie_policy
      response.should redirect_to root_path
    end

    it 'cookie has correct key/value pair' do
      get :allow_cookie_policy
      response.cookies['cookie_policy_accepted'].should be_true
    end
  end
end
