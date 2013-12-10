require 'spec_helper'

describe ContributorsController do

  describe "GET show" do
    before :each do
      @contributors = [
          {'login' => 'thomas', 'avatar_url' => 'http://example.com/thomas.png', 'html_url' => 'http://github.com/thomas', 'contributions' => 7},
          {'login' => 'john', 'avatar_url' => 'http://example.com/john.png', 'html_url' => 'http://github.com/john', 'contributions' => 9}
      ]
      json_data = @contributors.to_json

      stub_request(:get, /api.github.com/).
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => json_data, :headers => {})
    end

    it "assigns the contributors appropriately" do
      get :show
      assigns(:contributors).should eq(@contributors)
    end
  end
end
