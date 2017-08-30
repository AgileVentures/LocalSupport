describe('Organization map', function() {
  var validCoordinatesOrganization, emptyCoordinatesOrganiztion;
  beforeEach(function() {
    loadFixtures('organization_list.html');
    validCoordinatesOrganization = $('.center-map-on-op').first();
  });
  describe('when hovering the pointer over an organization', function() {
    describe('and the organization have valid coordinates', function() {
      beforeEach(function() {
        var getVolOpCoordinates = spyOn(window, 'getVolOpCoordinates');
      });
      it('gets organization coordinates', function() {
        validCoordinatesOrganization.trigger('mouseenter');
        expect(getVolOpCoordinates).toHaveBeenCalledWith();
      });
    });
  });
});
