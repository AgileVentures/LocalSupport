require 'rails_helper'

describe RegistrationsController, :type => :controller do
  describe "POST create" do
    before :each do
      request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp', 'password_confirmation' => 'pppppppp'}
    end

    it 'does email confirmation upon registration' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
      subjects = ActionMailer::Base.deliveries.map(&:subject)
      expect(subjects).to include 'Confirmation instructions'
    end

    it 'does not authenticate user' do
      expect(warden.authenticated?(:user)).to be false
    end

    it 'redirects to home page after registration form' do
      expect(response).to redirect_to root_url
    end

    it 'displays confirmation message upon registration' do
      expect(flash[:notice]).to have_content('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')
    end
  end

  describe "POST create that fails" do
     before :each do
      request.env["devise.mapping"] = Devise.mappings[:user]
      FactoryGirl.create :user, {:email => 'example@example.com', :password => 'pppppppp'}
    end
    it 'does not email upon failure to register' do
      post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp', 'password_confirmation' => 'pppppppp'}
      expect(ActionMailer::Base.deliveries.size).to eq 0
    end

    it 'has an active record error message in the user instance variable when registration fails due to email already being in db' do
      post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp', 'password_confirmation' => 'pppppppp'}
      expect(assigns(:user).errors.full_messages).to include "Email has already been taken"
    end

    it 'does not email when registration fails due to non-matching passwords' do
      post :create, 'user' => {'email' => 'example2@example.com', 'password' => 'pppppppp', 'password_confirmation' => 'aaaaaaaaaa'}
      expect(ActionMailer::Base.deliveries.size).to eq 0
    end

    it 'has an active record error message in the user instance variable when registration fails due to non matching passwords' do
      post :create, 'user' => {'email' => 'example2@example.com', 'password' => 'pppppppp', 'password_confirmation' => 'aaaaaaaaaa'}
      expect(assigns(:user).errors.full_messages).to include("Password confirmation doesn't match Password")
    end
  end
end
