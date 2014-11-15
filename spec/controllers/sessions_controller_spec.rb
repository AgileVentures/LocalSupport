require 'spec_helper'

describe SessionsController do
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

    it 'renders sign in page after someone fails to log-in with non-existent account' do
      post :create, 'user' => {'email' => 'example@example.com', 'password' => '12345'}
      expect(response).to be_ok
    end

    it 'displays warning flash after someone fails to log-in with non-existent account' do
      post :create, 'user' => {'email' => 'example@example.com', 'password' => '12345'}
      expect(flash[:alert]).to have_content "I'm sorry, you are not authorized to login to the system."
    end

    it 'redirects to charity page after non-admin associated with org' do
      usr = FactoryGirl.build(:user_stubbed_organisation, {:email => 'example@example.com', :password => 'pppppppp'})
      controller.stub(:session => {previous_url: "/"})
      post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
      expect(response).to redirect_to organisation_path(usr.organisation.id)
    end

  end
end
