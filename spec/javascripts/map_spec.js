describe('map.js', function() {
  describe('default settings', function() {
    it('', function() {
      expect(LocalSupport).toBeDefined();
      expect(LocalSupport.google_map).toBeDefined();
      expect(LocalSupport.google_map.element).toBeDefined();
      expect(LocalSupport.google_map.settings).toBeDefined();
      expect(LocalSupport.google_map.build).toBeDefined();
    });
  });
});
