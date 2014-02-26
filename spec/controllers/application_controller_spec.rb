require 'spec_helper'

describe ApplicationController do
  describe '#after_sign_in_path_for' do
    it 'should return organization path when user is associated with organization and has not previously visited the site' do
      controller = ApplicationController.new
      controller.stub(:store_location)
      controller.stub(:session).and_return({ :previous_url => nil })
      controller.stub(:organization_path).and_return '/organization/1'
      user = double('User')
      org = double('Organization')
      org.stub(:id).and_return 1
      user.stub(:organization).and_return org
      controller.stub(:current_user).and_return user
      controller.stub(:root_path).and_return '/'

      controller.after_sign_in_path_for(user).should eq '/organization/1'
    end
  end

  describe 'checking previous request paths stored in session' do
    controller do
      def custom
        render :text => "custom called"
      end
    end
    before(:each) { routes.draw { get "custom" => "anonymous#custom" } }

    describe 'unwanted previous URLS' do
      it 'when called from /cookies/allow' do
        request.stub(:path).and_return("/cookies/allow")
        get :custom
        session[:previous_url].should be_nil
      end
      it 'when called from /users/sign_in' do
        request.stub(:path).and_return("/users/sign_in")
        get :custom
        session[:previous_url].should be_nil
      end
      it 'when called from /users/sign_up' do
        request.stub(:path).and_return("/users/sign_up")
        get :custom
        session[:previous_url].should be_nil
      end
      it 'when called from /users/password' do
        request.stub(:path).and_return("/users/password")
        get :custom
        session[:previous_url].should be_nil
      end
      it 'when called from /users/confirmation' do
        request.stub(:path).and_return("/users/confirmation")
        get :custom
        session[:previous_url].should be_nil
      end
      it 'when called by ajax' do
        request.stub(:xhr?).and_return(true)
        get :custom
        session[:previous_url].should be_nil
      end

      it 'when called from /users/password/edit' do
        request.stub(:path).and_return("/users/password/edit")
        get :custom
        session[:previous_url].should be_nil
      end
    end
    describe 'wanted previous urls' do
      it 'when called from /organizations/1' do
        request.stub(:path).and_return("/organizations/1")
        get :custom
        session[:previous_url].should eq "/organizations/1"
      end
    end
  end

  describe 'allow_cookie_policy' do
    #before :each do
    #  request.should_receive(:referer).and_return "/hello"
    #end
    it 'cookie is set and redirected to referer' do
      request.should_receive(:referer).and_return "/hello"
      response.should_receive(:set_cookie)
      get :allow_cookie_policy
      response.should redirect_to "/hello"
    end

    it 'redirects to root if request referer is nil' do
      request.should_receive(:referer).and_return nil
      response.should_receive(:set_cookie)
      get :allow_cookie_policy
      response.should redirect_to '/'
    end

    it 'cookie has correct key/value pair' do
      request.should_receive(:referer).and_return "/hello"
      get :allow_cookie_policy
      response.cookies['cookie_policy_accepted'].should be_true
    end
  end
end
