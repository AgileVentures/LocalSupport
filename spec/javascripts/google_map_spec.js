//= require google-maps-loader/lib/Google


describe('LocalSupport.GoogleMap', function() {
  var map, settings;

  beforeEach(function(done) {
    originalTimeout = jasmine.DEFAULT_TIMEOUT_INTERVAL;
    jasmine.DEFAULT_TIMEOUT_INTERVAL = 10000;

    var marker_data = JSON.stringify([{
      custom_marker: "some image tag",
      index: -1,
      infowindow: "some html",
      lat: 51.5596612,
      lng: -0.358899
    }])

    setFixtures(sandbox({
      id: 'marker_data',
      'data-markers': marker_data,
    }));
    appendSetFixtures(sandbox({ id: 'map_canvas' }))

    GoogleMapsLoader.LIBRARIES = ['geometry'];
    GoogleMapsLoader.load(function(google) {
      settings = LocalSupport.MapSettings().for(google);
      done();
    });

    map = new LocalSupport.GoogleMap()
  });

  it('marker_data() reads JSON out of DOM node', function() {
    var data = map.marker_data()[0];
    expect(data.custom_marker).toEqual(jasmine.any(String));
    expect(data.index).toEqual(jasmine.any(Number));
    expect(data.infowindow).toEqual(jasmine.any(String));
    expect(data.lat).toEqual(jasmine.any(Number));
    expect(data.lng).toEqual(jasmine.any(Number));
  });

  it('handler() uses LocalSupport.MarkerBuilder', function() {
    expect(map.handler().builders.Marker.name).toEqual('MarkerBuilder')
  });

  it('build() works', function() {
    expect(function() {
      map.build(settings)
    }).not.toThrowError();
  });

  afterEach(function() {
    jasmine.DEFAULT_TIMEOUT_INTERVAL = originalTimeout;
  });
});
