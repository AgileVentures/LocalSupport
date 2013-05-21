require 'spec_helper'

describe Devise::RegistrationsController do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  describe "POST create" do
    it 'does not email upon registration' do
      request.env["devise.mapping"] = Devise.mappings[:charity_worker]
      post :create, '0' => {charity_worker: {'email' => 'example@example.com', 'password' => 'pppppppp', 'password_confirmation' => 'pppppppp'}}
      expect(response).to be_success
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end
