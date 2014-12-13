describe('LocalSupport.InfoWindowBuilderFactory', function() {
  var factory, google;

  beforeEach(function() {
    google = {
      maps: {
        Size: function(lat, lng) {
          this.msg = 'I am just a mock object!'
          this.lat = lat;
          this.lng = lng;
        }
      }
    };
    factory = LocalSupport.InfoWindowBuilderFactory(google).fetchBuilder;
  });

  it('', function() {
    expect(factory('vol_op').klass()).toEqual('arrow_box_vol_op')
    expect(factory('vol_op').infobox('hi')).toEqual({
      content: 'hi',
      pixelOffset: jasmine.any(Object)
    })
  });
});
