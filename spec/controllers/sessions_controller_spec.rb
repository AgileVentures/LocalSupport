require 'rails_helper'

describe SessionsController, :type => :controller do
  describe "POST create" do
    before :each do
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it 'redirects to home page after superadmin logs-in' do
      FactoryGirl.build(:user, {:email => 'example@example.com', :password => 'pppppppp', :superadmin => true}).save!
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

    it 'redirects to charity page after non-superadmin associated with org' do
      usr = FactoryGirl.build(:user_stubbed_organisation, {:email => 'example@example.com', :password => 'pppppppp'})
      allow(controller).to receive_messages :session => {previous_url: "/"}
      post :create, 'user' => {'email' => 'example@example.com', 'password' => 'pppppppp'}
      expect(response).to redirect_to organisation_path(usr.organisation)
    end

  end
end
