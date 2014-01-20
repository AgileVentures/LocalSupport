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
        request.stub(:path_info).and_return("/users/sign_in")
        ApplicationController.any_instance.should_receive(:store_location)
        get :custom
        session[:previous_url].should be_nil
      end
      it 'when called from /users/sign_up' do
        request.stub(:path_info).and_return("/users/sign_up")
        ApplicationController.any_instance.should_receive(:store_location)
        get :custom
        session[:previous_url].should be_nil
      end
      it 'when called from /users/password' do
        request.stub(:path_info).and_return("/users/password")
        ApplicationController.any_instance.should_receive(:store_location)
        get :custom
        session[:previous_url].should be_nil
      end
      it 'when called by ajax' do
        request.stub(:xhr?).and_return(true)
        ApplicationController.any_instance.should_receive(:store_location)
        get :custom
        session[:previous_url].should be_nil
      end
    end
    describe 'wanted previous urls' do
      #
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
