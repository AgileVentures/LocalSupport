describe('Interaction with Google Maps API', function () {
    setFixtures('<script src="//maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>');
    appendSetFixtures(sandbox( { id:'map-canvas' } ));
    beforeEach(function () {
        this.loadMapSpy = spyOn(LocalSupport.maps, 'loadMap').and.callThrough();
        this.loadMarkerSpy = spyOn(LocalSupport.maps, 'loadMarker').and.callThrough();
        this.coordinates = spyOn(google.maps, 'LatLng').andReturn(jasmine.createSpy('LatLng'));
        this.map = spyOn(google.maps, 'Map').andReturn(jasmine.createSpy('Map'));
        this.marker = spyOn(google.maps, 'Marker').andReturn(jasmine.createSpy('Marker'));
        this.infowindow = spyOn(google.maps, 'InfoWindow').andReturn(jasmine.createSpy('InfoWindow'));
        spyOn(google.maps.event, 'addListener');
        LocalSupport.maps.data = [
            {
                id: '1',
                name: 'sample organization',
                description: 'I am a unique snowflake',
                latitude: '0.05',
                longitude: '0.05'
           }
        ];
    });

    it('should call LocalSupport.maps.loadMap function', function() {
        expect(this.loadMapSpy).toHaveBeenCalled();
    });

    it('should call LocalSupport.maps.loadMarker with the org', function() {
        expect(this.loadMarkerSpy).toHaveBeenCalledWith(LocalSupport.maps.data[0]);
    });

    describe('Localsupport.LoadMarker()', function() {
        it('call to google.maps.InfoWindow', function() {
            expect(this.infowindow).toHaveBeenCalledWith({
                content: '<a href="/organizations/1">sample organization</a><br>I am a unique snowflake',
                position: this.coordinates,
                disableAutoPan: true
            })
        });

    });
});

