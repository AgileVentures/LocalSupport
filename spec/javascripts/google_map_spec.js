describe('LocalSupport.GoogleMap', function() {
  var map;

  beforeEach(function() {
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

});
