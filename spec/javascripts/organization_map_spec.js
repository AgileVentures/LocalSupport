describe('Organization map', function() {
  var validCoordinatesOrganization, emptyCoordinatesOrganiztion;
  beforeEach(function() {

  });

  describe('when hovering the pointer over an organization', function() {
    describe('and the organization have valid coordinates', function() {
      beforeEach(function() {
        loadFixtures('organization_list.html');
        OrganizationMap.initMap();
        OrganizationMap.init();
        spyOn(OrganizationMap, 'getVolOpCoordinates').and.callThrough();
        $('#valid-organization').trigger('mouseenter');
      });
      it('gets organization coordinates', function() {
        expect(OrganizationMap.getVolOpCoordinates).toHaveBeenCalled();
      });
    });
  });
});
