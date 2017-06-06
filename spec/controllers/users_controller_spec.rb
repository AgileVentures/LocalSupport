require 'rails_helper'

describe UsersController, :type => :controller do
  describe "strong params" do
    it "only permits the pre-defined param values" do
      permit(:id, :email, :email, :password, :password_confirmation).for(:update, params: {id: 5})
    end
  end
end
