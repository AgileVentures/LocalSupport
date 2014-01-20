require 'spec_helper'

describe ApplicationController do
  describe 'after_sign_in_path' do
    controller do
      def custom
        render :text => "custom called"
      end
    end
    before(:each) { routes.draw { get "custom" => "anonymous#custom" } }

    describe 'unwanted previous URLS' do
      it 'when called from /users/sign_in' do
        request.stub(:fullpath).and_return("/users/sign_in")
        get :custom
        session[:previous_url].should be_nil
      end
      it 'when called from /users/sign_up' do
        request.stub(:fullpath).and_return("/users/sign_up")
        get :custom
        session[:previous_url].should be_nil
      end
      it 'when called from /users/password' do
        request.stub(:fullpath).and_return("/users/password")
        get :custom
        session[:previous_url].should be_nil
      end
      it 'when called by ajax' do
        request.stub(:xhr?).and_return(true)
        get :custom
        session[:previous_url].should be_nil
      end
    end
    describe 'wanted previous urls' do
      it 'when called from /organizations/1' do
        request.stub(:fullpath).and_return("/organizations/1")
        get :custom
        session[:previous_url].should eq "/organizations/1"
      end
    end
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
