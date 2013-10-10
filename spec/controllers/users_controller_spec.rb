require 'spec_helper'
require 'ruby-debug'

describe UsersController do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
    @user = FactoryGirl.create(:user,email: 'user1@org.com')
  end

  describe "GET index" do
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
end
