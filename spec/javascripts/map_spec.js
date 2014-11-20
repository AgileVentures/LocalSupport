describe('Integration with gmaps4rails and Google maps API', function() {
  beforeEach(function() {
    setFixtures(sandbox({
      id: 'marker_data',
      'data-markers': 'my-markers',
    }));
  });
  it('parsed_settings', function() {
    var map = LocalSupport.google_map;
    var parsed_settings = map.parsed_settings(google, map.settings);
    expect(parsed_settings.internal).toEqual({id: 'map_canvas'});
    expect(parsed_settings.provider).toEqual({
      zoom: 12,
      center: new google.maps.LatLng(51.5978, -0.337)
    });
  });

  it('marker_data', function() {
    var map = LocalSupport.google_map;
    expect(map.marker_data()).toBe('my-markers');
  });
});
