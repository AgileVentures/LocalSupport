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
      flash[:notice].should_not eql "You have requested admin status for My Organization"
      expect(response).to redirect_to root_url
    end

    context 'organization id is set in session' do
      before(:each) do
        @org = FactoryGirl.build(:organization)
        Gmaps4rails.should_receive(:geocode)
        @org.save!
        @user = FactoryGirl.build(:user, {email: "nonadmin@myorg.com", password: "password"})
        @user.save!
        session[:previous_url] = "/organizations/#{@org.id}"
        session[:organization_id] = "@org.id"
      end

      it 'redirects to charity page after user who has requested admin status for org logs in' do
        FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp',:charity_admin_pending => true ,:pending_organization_id => @org.id}).save!
        post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
        expect(response).to redirect_to organization_path(@org.id)
      end
    end

      it 'redirects to charity page after user associated with org logs in' do
        org = FactoryGirl.build(:organization)
        Gmaps4rails.should_receive(:geocode)
        org.save!
        FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp', :organization => org}).save!
        post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
        expect(response).to redirect_to organization_path(org.id)
      end
  end
end
