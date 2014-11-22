describe('Integration with gmaps4rails and Google maps API', function() {
  var google;

  beforeEach(function() {
    setFixtures(sandbox({
      id: 'marker_data',
      'data-markers': 'my-markers',
    }));

    google = {
      maps: {
        LatLng: function(lat, lng) {
          this.msg = 'I am just a mock object!'
          this.lat = lat;
          this.lng = lng;
        }
      }
    }

  });

  it('parsed_settings', function() {
    var map = LocalSupport.google_map;
    var parsed_settings = map.parsed_settings(google, map.settings);

    expect(parsed_settings.internal.id).toBe('map_canvas');
    expect(parsed_settings.provider.zoom).toBe(12);
    expect(parsed_settings.provider.center.lat).toBe(51.5978);
    expect(parsed_settings.provider.center.lng).toBe(-0.337);
  });

  it('marker_data', function() {
    var map = LocalSupport.google_map;
    expect(map.marker_data()).toBe('my-markers');
  });
});
