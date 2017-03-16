require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(302)
    end
  end

end
