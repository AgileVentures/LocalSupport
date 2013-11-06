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
      expect(response).to redirect_to root_url
    end

    it 'renders sign in page after non-admin associated with nothing fails to log-in' do
      FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp'}).save!
      post :create, 'user' => {'email' => 'example@example.com', 'password' => '12345'}
      expect(response).to be_ok
    end

    it 'displays warning flash after non-admin associated with nothing fails to log-in' do
      FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp'}).save!
      post :create, 'user' => {'email' => 'example@example.com', 'password' => '12345'}
      expect(flash[:alert]).to have_content "I'm sorry, you are not authorized to login to the system."
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
