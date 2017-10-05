describe('Organization map', function() {
  var validCoordinatesOrganization, emptyCoordinatesOrganiztion;
  beforeEach(function() {
    loadFixtures('organization_list.html');
    OrganizationMap.initMap();
    OrganizationMap.init();
    spyOn(OrganizationMap, 'getVolOpCoordinates').and.callThrough();
  });

  describe('when hovering the pointer over an organization', function() {

    
    describe('and the organization have invalid coordinates', function() {
      beforeEach(function() {
        $('#invalid-organisation').trigger('mouseenter');
      });
      it('does not get organization coordinates', function() {
        expect(OrganizationMap.getVolOpCoordinates).not.toHaveBeenCalled();
      })
    })
    
    describe('and the organization have valid coordinates', function() {
      beforeEach(function() {
        $('#valid-organization').trigger('mouseenter');
      });
      it('gets organization coordinates', function() {
        expect(OrganizationMap.getVolOpCoordinates).toHaveBeenCalled();
      });
    });
  });
});
