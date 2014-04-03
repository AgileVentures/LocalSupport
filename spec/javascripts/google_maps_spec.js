describe('Interaction with Google Maps API', function () {
    var invite_users, select_all;
    beforeEach(function () {
        setFixtures(sandbox({id:'map'}));
        spyOn(google.maps, 'LatLng')
        spyOn(google.maps, 'Map')
        spyOn(google.maps, 'Marker')
        spyOn(google.maps, 'InfoWindow')
        spyOn(google.maps.event, 'addListener')
    });
});

