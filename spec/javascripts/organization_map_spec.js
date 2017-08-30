describe('Organization map', function() {
  var validCoordinatesOrganization, emptyCoordinatesOrganiztion, organizationList;
  beforeEach(function() {

  });
  describe('when hovering the pointer over an organization', function() {
    describe('and the organization have valid coordinates', function() {
      beforeEach(function() {
        loadFixtures('organization_list.html');
        spyOn(window, 'getVolOpCoordinates');
        $('#valid-organization').trigger('mouseenter');
      });
      it('gets organization coordinates', function() {
        expect(window.getVolOpCoordinates).toHaveBeenCalled();
      });
    });
  });
});
