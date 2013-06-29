require 'spec_helper'

describe Devise::RegistrationsController do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  describe "POST create" do
    before :each do
      request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp', 'password_confirmation' => 'pppppppp'}
    end

    it 'does email upon registration' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it 'does not authenticate user' do
      expect(warden.authenticated?(:user)).to be_false
    end

    it 'redirects to home page after registration form' do
      expect(response).to redirect_to root_url
    end
  end
end
