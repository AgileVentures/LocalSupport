require 'rails_helper'

describe Devise::PasswordsController, :type => :controller do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  describe "POST create" do
    before :each do
      request.env["devise.mapping"] = Devise.mappings[:user]
    end
    context "successful" do
      before :each do
        FactoryGirl.create(:user)
        post :create, 'user' => {'email' => 'jj@example.com'}
      end

      it 'emails when user requests password for email in the system' do
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it 'displays flash message when password retrieval succeeds' do
        expect(flash[:notice]).to have_content "You will receive an email with instructions about how to reset your password in a few minutes."
      end


      it 'redirects to sign-in after user requests password for email in the system' do
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "unsuccessful" do
      before :each do
        post :create, 'user' => {'email' => 'jj@example.com'}
      end
      it 'displays message when password retrieval is a no-go' do
        expect(assigns(:user).errors.full_messages).to include "Email not found in our database. Sorry!"
      end
    end
   end
end
