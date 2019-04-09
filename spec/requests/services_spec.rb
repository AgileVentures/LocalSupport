require 'rails_helper'

RSpec.describe "Services", type: :request do
  describe "GET /services" do
    it "works! (now write some real specs)" do
      get services_path
      expect(response).to have_http_status(200)
    end
  end
end
