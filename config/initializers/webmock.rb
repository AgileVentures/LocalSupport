def stub_google_maps
  stub_request(:any, /maps\.googleapis\.com/).to_rack(FakeGoogleGeocode)
end

def stub_twitter
  stub_request(:post, "https://api.twitter.com/1.1/statuses/update.json").
    to_return(:status => 200,
              :body => File.read('test/fixtures/update_twitter.json'),
              :headers => {'Content-Type' => 'application/json'})
end

if ENV["RAILS_ENV"] == 'test'
  require 'webmock'
  # Stub out network calls and return fixtures with sinatra's help
  WebMock.disable_net_connect!(allow_localhost: true)
  require "#{Rails.root}/test/fake_google_geocode"
  if ENV['RSPEC']
    RSpec.configure do |r|
      r.before(:each) do
        stub_google_maps
        stub_twitter
      end
    end
  end
end
