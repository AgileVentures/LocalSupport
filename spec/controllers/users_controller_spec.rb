require 'spec_helper'
require 'ruby-debug'

describe UsersController do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
    @user = FactoryGirl.create(:user,email: 'user1@org.com')
  end

  describe "GET index" do
    context "while signed in as admin" do
      before(:each) do
        user = double("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
        user.should_receive(:admin?).and_return(true)
      end
      it 'should display all users' do
        User.should_receive(:all) #.with(false).and_return(@user)
        get :index, :charity_admin_pending => "false"
      end
      it 'should display users awaiting admin approval' do
        User.should_receive(:find_all_by_charity_admin_pending) #.with(true).and_return(@user)
        get :index, :charity_admin_pending => "true"
      end
      it "renders the users index" do
        get :index, :charity_admin_pending => "true"
        response.should render_template 'index'
      end
    end
    context "while signed in as non-admin" do
      before(:each) do
        user = double("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
        user.should_receive(:admin?).and_return(false)
      end
      it "sends a message to the flash" do
        get :index, :charity_admin_pending => "true"
        expect(flash[:alert]).to eq("You must be signed in as admin to perform that action!")
      end
      it "redirects to root path" do
        get :index
        expect(response).to redirect_to root_path
      end
    end
    context "while not signed in" do
      it "redirects to sign-in" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
