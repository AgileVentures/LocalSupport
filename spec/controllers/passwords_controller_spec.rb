require 'spec_helper'

describe Devise::PasswordsController do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  describe "POST create" do
    it 'emails when user forgets password' do
      FactoryGirl.create(:charity_worker)
      request.env["devise.mapping"] = Devise.mappings[:charity_worker]
      post :create, 'charity_worker' => {'email' => 'jj@example.com'}
      expect(response).to redirect_to new_charity_worker_session_path
      expect(ActionMailer::Base.deliveries).not_to be_empty
    end
  end
end
