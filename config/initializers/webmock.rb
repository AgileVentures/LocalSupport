def stub_google_maps
  stub_request(:any, /maps\.googleapis\.com/).to_rack(FakeGoogleGeocode)
end

if ENV["RAILS_ENV"] == 'test'
  require 'webmock'
  # Stub out network calls and return fixtures with sinatra's help
  WebMock.disable_net_connect!(allow_localhost: true)
  require "#{Rails.root}/test/fake_google_geocode"
  if ENV['RSPEC']
    RSpec.configure {|r| r.before(:each) { stub_google_maps } }
  end
end
