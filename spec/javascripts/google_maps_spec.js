describe('Interaction with Google Maps API', function () {
    var coordinates_stub, coordinates_mock, map_stub, map_mock, marker_stub, marker_mock, infowindow_stub, infowindow_mock, script;

    beforeEach(function () {
        setFixtures(sandbox({ id: 'map-canvas' }));

        coordinates_mock = jasmine.createSpy('LatLng');
        map_mock = jasmine.createSpy('Map');
        marker_mock = jasmine.createSpyObj('Marker', ['setMap']);
        infowindow_mock = jasmine.createSpyObj('InfoWindow', ['open', 'close']);
        coordinates_stub = spyOn(google.maps, 'LatLng').and.returnValue(coordinates_mock);
        map_stub = spyOn(google.maps, 'Map').and.returnValue(map_mock);
        marker_stub = spyOn(google.maps, 'Marker').and.returnValue(marker_mock);
        infowindow_stub = spyOn(google.maps, 'InfoWindow').and.returnValue(infowindow_mock);
        spyOn(google.maps.event, 'addListener');


        script = LocalSupport.maps;
        script.data = [
            {
                id: '1',
                name: 'sample organization',
                description: 'I am a unique snowflake',
                latitude: '0.05',
                longitude: '0.05'
            }
        ];
    });

    describe('loadMap()', function() {
        var args;
        beforeEach(function() {
            script.loadMap();
            args = map_stub.calls.mostRecent().args
        });
        it('sets map zoom level and center', function() {
            expect(args[1].zoom).toEqual(jasmine.any(Number));
            expect(args[1].center).toEqual(coordinates_mock)
        });
        it('displays the map in the given div', function() {
            expect(args[0].id).toEqual('map-canvas')
        })
    });

    describe('loadMarker()', function() {
        beforeEach(function() {
            var map_instance = script.loadMap();
            script.data.forEach(function(org) {
                script.loadMarker(map_instance, org)
            });
        });
        it('sets marker position', function() {
            var args = coordinates_stub.calls.mostRecent().args;
            expect(args).toEqual(['0.05', '0.05'])
        });
        it('sets marker name for popover on hover', function() {
            var args = marker_stub.calls.mostRecent().args[0];
            expect(args.title).toEqual('sample organization')
        });
        it('sets HTML for marker info window contents', function() {
            var args = infowindow_stub.calls.mostRecent().args[0];
            expect(args.content).toEqual('<a href="/organizations/1">sample organization</a><br>I am a unique snowflake');
        });

        describe('clicking on a marker', function() {
            it('opens an info window', function() {
                marker_mock.infoWindow = infowindow_mock;
                marker_mock.click()
                expect(infowindow_mock.open).toHaveBeenCalled()
            })
        })
    });
});

