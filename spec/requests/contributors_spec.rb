require 'rails_helper'

describe "Contributors", :type => :request do
  describe "GET /contributors" do
    before :each do
      contributors = ([
          {'login' => 'thomas', 'avatar_url' => 'http://example.com/thomas.png', 'html_url' => 'http://github.com/thomas', 'contributions' => 7},
          {'login' => 'john', 'avatar_url' => 'http://example.com/john.png', 'html_url' => 'http://github.com/john', 'contributions' => 9}
      ]).to_json

      stub_request(:get, /api.github.com/).
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => contributors, :headers => {})
    end
    it "contributors path should return 200" do
      get contributors_path
      expect(response.code).to eq('200')
    end
  end
end
