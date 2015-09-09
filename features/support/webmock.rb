require 'webmock/cucumber'
Before {stub_request(:any, /maps\.googleapis\.com/).to_rack(FakeGoogleGeocode)}
