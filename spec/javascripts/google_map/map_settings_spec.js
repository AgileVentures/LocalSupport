describe('LocalSupport.MapSettings', function() {
  var google;

  beforeEach(function() {
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

  it('expresses default settings in terms of internal and provider objects', function() {
    var settings = LocalSupport.MapSettings().for(google);
    expect(settings.internal.id).toBe('map_canvas');
    expect(settings.provider.zoom).toBe(12);
    expect(settings.provider.center.lat).toBe(51.5978);
    expect(settings.provider.center.lng).toBe(-0.337);
  });
});
