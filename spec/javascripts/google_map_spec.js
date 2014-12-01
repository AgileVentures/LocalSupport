//= require google-maps-loader/lib/Google


describe('LocalSupport.GoogleMap', function() {

  beforeEach(function() {
    originalTimeout = jasmine.DEFAULT_TIMEOUT_INTERVAL;
    jasmine.DEFAULT_TIMEOUT_INTERVAL = 10000;
  });

  it('expresses default settings in terms of internal and provider objects', function() {
    GoogleMapsLoader.LIBRARIES = ['geometry', 'places'];
    GoogleMapsLoader.load(function(google) {
      setFixtures(sandbox({
        id: 'marker_data',
        'data-markers': 'my-markers',
      }));
      appendSetFixtures(sandbox({ id: 'map_canvas' }))
      var settings = LocalSupport.MapSettings().for(google);
      debugger
      LocalSupport.GoogleMap().build(settings);
    });
    // setTimeout(function() {
    //   done();
    // }, 9000);
  });

  afterEach(function() {
    jasmine.DEFAULT_TIMEOUT_INTERVAL = originalTimeout;
  });
});
