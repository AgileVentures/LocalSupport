describe('Maps settings', function() {

  it('expresses default settings', function() {

    expect(Settings.id).toBe('map-canvas');
    expect(Settings.zoom).toBe(12);
    expect(Settings.lat).toBe(51.5978);
    expect(Settings.lng).toBe(-0.337);

  });
});
