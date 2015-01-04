describe('LocalSupport.InfoWindowBuilderFactory', function() {
    var factory, google;

    beforeEach(function() {
      google = {
        maps: {
          Size: function(x, y) {
            this.msg = 'I am just a mock object!'
            this.x = x;
            this.y = y;
          }
        }
      };
      factory = LocalSupport.InfoWindowBuilderFactory;
    });

    it('Volops infobox', function() {
      expect(factory(google, 'vol_op').infobox('hi').content).toEqual('hi')
      expect(factory(google, 'vol_op').infobox('hi').pixelOffset.x).toEqual(-151)
      expect(factory(google, 'vol_op').infobox('hi').pixelOffset.y).toEqual(10)
    });

    it('Small org infobox', function() {
      expect(factory(google, 'small_org').infobox('hi').content).toEqual('hi')
      expect(factory(google, 'small_org').infobox('hi').pixelOffset.x).toEqual(-151)
      expect(factory(google, 'small_org').infobox('hi').pixelOffset.y).toEqual(5)
    });

    it('Large org infobox', function() {
      expect(factory(google, 'large_org').infobox('hi').content).toEqual('hi')
      expect(factory(google, 'large_org').infobox('hi').pixelOffset.x).toEqual(-151)
      expect(factory(google, 'large_org').infobox('hi').pixelOffset.y).toEqual(10)
    });
});