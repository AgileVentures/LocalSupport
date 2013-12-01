require 'spec_helper'

describe "custom errors" do
  describe "GET /doesnotexist" do
    it "renders 404 on request that does not exist" do
      get '/doesnotexist'
      response.response_code.should eq 404
    end
  end
end