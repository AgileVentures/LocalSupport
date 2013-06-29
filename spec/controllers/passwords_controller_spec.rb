require 'spec_helper'

describe Devise::PasswordsController do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  describe "POST create" do
    before :each do
      FactoryGirl.create(:user)
      request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, 'user' => {'email' => 'jj@example.com'}
    end

    it 'emails when user requests password for email in the system' do
      expect(ActionMailer::Base.deliveries).not_to be_empty
    end

    it 'redirects to sign-in after user requests password for email in the system' do
      expect(response).to redirect_to new_user_session_path
    end
  end
end
