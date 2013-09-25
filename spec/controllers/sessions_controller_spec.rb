require 'spec_helper'

describe Devise::SessionsController do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  describe "POST create" do
    before :each do
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it 'redirects to home page after admin logs-in' do
      FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp', :admin => true}).save!
      post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
      expect(response).to redirect_to root_url
    end

    it 'redirects to home page after non-admin associated with nothing logs-in' do
      FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp'}).save!
      post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
      flash[:notice].should_not eql "you have requested admin status on My Organization"
      expect(response).to redirect_to root_url
    end

    context 'organization id is set in session' do
      before(:each) do
        FactoryGirl.build(:user, {email: "nonadmin@myorg.com", password: "password"}).save!
        session[:organization_id] = "5"
      end
      
      it 'sets the message in the flash scope about requesting for the user to be admin' do
        post :create, 'user' => {email: "nonadmin@myorg.com", password: "password"}
        flash[:notice].should eql "you have requested admin status on My Organization"
      end
    end

    it 'redirects to charity page after non-admin associated with org' do
      org = FactoryGirl.build(:organization)
      Gmaps4rails.should_receive(:geocode)
      org.save!
      FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp', :organization => org}).save!
      post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
      expect(response).to redirect_to organization_path(org.id)
    end
  end
end
