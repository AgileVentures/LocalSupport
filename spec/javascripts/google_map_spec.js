//= require google-maps-loader/lib/Google


describe('LocalSupport.GoogleMap', function() {
  var settings;

  beforeEach(function(done) {
    originalTimeout = jasmine.DEFAULT_TIMEOUT_INTERVAL;
    jasmine.DEFAULT_TIMEOUT_INTERVAL = 10000;

    setFixtures(sandbox({
      id: 'marker_data',
      'data-markers': 'my-markers',
    }));
    appendSetFixtures(sandbox({ id: 'map_canvas' }))

    GoogleMapsLoader.LIBRARIES = ['geometry'];
    GoogleMapsLoader.load(function(google) {
      settings = LocalSupport.MapSettings().for(google);
      done();
    });
  });

  it('expresses default settings in terms of internal and provider objects', function() {
    debugger
    LocalSupport.GoogleMap().build(settings);
  });

  afterEach(function() {
    jasmine.DEFAULT_TIMEOUT_INTERVAL = originalTimeout;
  });
});
