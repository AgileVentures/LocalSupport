require 'webmock/cucumber'
Before {stub_request(:any, /maps\.googleapis\.com/).to_rack(FakeGoogleGeocode)}
Before {stub_request(:get, "https://api.do-it.org/v1/opportunities?lat=51.5978&lng=-0.3370&miles=0.5").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "[]", :headers => {})}
