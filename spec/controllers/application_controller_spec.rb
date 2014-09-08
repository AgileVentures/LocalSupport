require 'spec_helper'

describe ApplicationController, :helpers => :controllers do
  it '#request_controller_is(white_listed)' do
    controller.stub :white_listed => %w(a b c)
    request.stub :params => { 'controller' => 'a' }
    controller.request_controller_is(controller.white_listed).should be_true

    request.stub :params => { 'controller' => 'd' }
    controller.request_controller_is(controller.white_listed).should be_false
  end

  it '#request_verb_is_get?' do
    request.env['REQUEST_METHOD'] = 'GET'
    controller.request_verb_is_get?.should be_true

    request.env['REQUEST_METHOD'] = 'PUT'
    controller.request_verb_is_get?.should be_false
  end

  it '#store_location stores URLs only when conditions permit' do
    request.stub :path => 'this/is/a/path'

    controller.stub :request_controller_is => false
    controller.stub :request_verb_is_get? => false
    controller.store_location
    session[:previous_url].should be_nil

    controller.stub :request_controller_is => true
    controller.store_location
    session[:previous_url].should be_nil

    controller.stub :request_verb_is_get? => true
    controller.store_location
    session[:previous_url].should eq request.path
  end

  it '#after_sign_in_path_for' do
    user = make_current_user_nonadmin
    user.stub :organisation => nil

    controller.after_sign_in_path_for(user).should eq '/'

    user.stub :organisation => '1'
    controller.after_sign_in_path_for(user).should eq '/organisations/1'

    session[:previous_url] = 'i/was/here'
    controller.after_sign_in_path_for(user).should eq 'i/was/here'
  end

  it '#after_accept_path_for' do
    user = make_current_user_nonadmin
    user.stub :organisation => nil

    controller.after_accept_path_for(user).should eq '/'

    user.stub :organisation => '1'
    controller.after_accept_path_for(user).should eq '/organisations/1'
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

  describe '#assign_footer_page_links' do
    it 'calls the model method that provides visible page links' do
      expect(Page).to receive(:visible_links).and_return(nil)
      subject.send(:assign_footer_page_links)  
    end
    it 'makes the visible page links available to the view' do
      fake_links = Object.new
      Page.stub(:visible_links).and_return(fake_links)
      subject.send(:assign_footer_page_links)  
      expect(assigns(:footer_page_links)).to be fake_links
    end
  end

  describe 'PRIVATE METHODS' do
    let(:user) { double :user }
    before { controller.stub current_user: user }

    context '#authorize' do
      it 'Unauthorized: redirects to root_path and displays flash' do
        controller.stub admin?: false
        controller.should_receive(:redirect_to).with(root_path) { true } # calling original raises errors
        controller.flash.should_receive(:[]=)
          .with(:error, 'You must be signed in as an admin to perform this action!')
          .and_call_original
        controller.instance_eval { authorize }.should be false
        # can't assert `redirect_to root_path`: http://owowthathurts.blogspot.com/2013/08/rspec-response-delegation-error-fix.html
        flash[:error].should_not be_nil
      end

      it 'Authorized: allows execution to continue' do
        controller.stub admin?: true
        controller.instance_eval { authorize }.should be nil
      end
    end

    context '#admin?' do
      it 'returns false when current_user is nil' do
        controller.stub current_user: nil
        controller.instance_eval { admin? }.should be_false
      end

      it 'otherwise depends on { current_user.admin? }' do
        user.should_receive(:admin?) { false }
        controller.instance_eval { admin? }.should be false
        user.should_receive(:admin?) { true }
        controller.instance_eval { admin? }.should be true
      end
    end
  end
end

# all child controllers should implement the ApplicationController's
# before_filter
describe OrganisationsController do
  it 'assigns footer page links on a given request' do
    get :index
    expect(assigns(:footer_page_links)).not_to be nil
  end
end

