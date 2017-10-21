describe('Organisation map', function() {
  var validCoordinatesOrganization, emptyCoordinatesOrganiztion;
  beforeEach(function() {
    loadFixtures('organisation_list.html');
    OrganisationMap.initMap();
    OrganisationMap.init();
    spyOn(OrganisationMap, 'getVolOpCoordinates').and.callThrough();
    spyOn(OrganisationMap, 'centerMap').and.callThrough();
    spyOn(OrganisationMap, 'openInfoBox').and.callThrough();
  });

  describe('when hovering the pointer over an organisation', function() {

    
    describe('and the organisation have invalid coordinates', function() {
      beforeEach(function() {
        $('#invalid-organisation').trigger('mouseenter');
      });
      it('does not get organisation coordinates', function() {
        expect(OrganisationMap.getVolOpCoordinates).not.toHaveBeenCalled();
        expect(OrganisationMap.centerMap).not.toHaveBeenCalled();
        expect(OrganisationMap.openInfoBox).not.toHaveBeenCalled();
      })
    })
    
    describe('and the organisation have valid coordinates', function() {
      beforeEach(function() {
        $('#valid-organisation').trigger('mouseenter');
      });
      it('gets organisation coordinates', function() {
        expect(OrganisationMap.getVolOpCoordinates).toHaveBeenCalled();
        expect(OrganisationMap.centerMap).toHaveBeenCalled();
        expect(OrganisationMap.openInfoBox).toHaveBeenCalled();
      });
    });
  });
});
