require 'spec_helper'

describe "Contributors" do
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
    it "a call to GitHub API should result in a 200 responce and return JSON" do
      url = 'https://api.github.com/repos/tansaku/LocalSupport/contributors'
      uri = URI.parse url
      request = Net::HTTP::Get.new(uri.request_uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      response = http.request(request)
      data = response.body
      contributors = JSON.parse(data)
      expect(response.code).to eq('200')
      #response.code.should == 200
      expect(contributors.count).to eq(2)
      expect(contributors.first['login']).to eq 'thomas'
      expect(contributors.last['login']).to eq 'john'
    end

  end
end