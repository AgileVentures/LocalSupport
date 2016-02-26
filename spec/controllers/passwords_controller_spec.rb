require 'rails_helper'

describe Devise::PasswordsController, :type => :controller do
  describe "POST create" do
    before :each do
      request.env["devise.mapping"] = Devise.mappings[:user]
    end
    context "successful" do
      before :each do
        usr = FactoryGirl.create(:user)
        post :create, 'user' => {'email' => usr.email}
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
   describe 'PATCH update' do
     before :each do
       request.env["devise.mapping"] = Devise.mappings[:user]
     end
     let(:user){ FactoryGirl.create(:user) }
     let(:reset_password_token){ user.send_reset_password_instructions }
     subject(:change_password){ put :update, user:
       { reset_password_token: reset_password_token, password: '123qwe___', password_confirmation: '123qwe___' } }
     context 'successfully' do
       it 'changes password' do
         change_password
         expect(flash[:notice]).to eq('Your password was changed successfully. You are now signed in.')
       end
     end
     context 'unsuccessfully' do
#      render_views
       it 'incorrect reset password token' do
         put :update, user:
           { reset_password_token: 'abracadabra', password: '123qwe___', password_confirmation: '123qwe___' }
         expect(assigns(:user).errors.full_messages).to include "Reset password token is invalid"
#        expect(response.body).to have_content('Reset password token is invalid')
       end
     end
   end
end
