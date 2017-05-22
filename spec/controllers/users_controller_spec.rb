require 'rails_helper'

describe UsersController, :type => :controller do
  describe ".permit" do
    it "returns the cleaned params" do
      user_params = {id: 5, email: "a@a.com", password: "blahblah", password_confirmation: "blahblah", 
       remember_me: true, pending_organisation_id: 5, superadmin: true}
      params = ActionController::Parameters.new.merge(user_params)
      permitted_params = UsersController::UserParams.build(params)
      expect(permitted_params).to eq({id: 5, email: "a@a.com", password: "blahblah", password_confirmation: "blahblah", 
       remember_me: true, pending_organisation_id: 5}.with_indifferent_access)
    end
  end
end
