require 'spec_helper'
require 'ruby-debug'

describe UsersController do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
    @user = FactoryGirl.create(:user,email: 'user1@org.com')
  end

  describe "index" do

    it 'should display users' do
      #User.should_receive(:find_all_by_charity_admin).with(false).and_return(@user)
      User.should_receive(:all)
      #debugger
      #get :index, :charity_admin => false
      get :index
    end
  end
end
