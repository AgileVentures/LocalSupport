describe('Interaction with Google Maps API', function () {
    var coordinates_stub, coordinates_mock, map_stub, map_mock, marker_stub, marker_mock, infowindow_stub, infowindow_mock, script, org;

    beforeEach(function () {
        setFixtures(sandbox({ id: 'map-canvas' }));
        appendSetFixtures('<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>')

//        coordinates_mock = jasmine.createSpy('LatLng');
//        map_mock = jasmine.createSpy('Map');
//        marker_mock = jasmine.createSpyObj('Marker', ['setMap']);
        infowindow_mock = jasmine.createSpyObj('InfoWindow', ['open', 'close']);
//        coordinates_stub = spyOn(google.maps, 'LatLng').and.returnValue(coordinates_mock);
//        map_stub = spyOn(google.maps, 'Map').and.returnValue(map_mock);
//        marker_stub = spyOn(google.maps, 'Marker').and.returnValue(marker_mock);
//        infowindow_stub = spyOn(google.maps, 'InfoWindow').and.returnValue(infowindow_mock);
//        spyOn(google.maps.event, 'addListener');

        org = {
            id: '1',
            name: 'sample organization',
            description: 'I am a unique snowflake',
            latitude: '51.5000000',
            longitude: '-0.5000000'
        };
        script = LocalSupport.maps;
        script.data = [ org ];
    });

//    describe('loadMap()', function() {
//        var args;
//        beforeEach(function() {
//            script.loadMap();
//            args = map_stub.calls.mostRecent().args
//        });
//        it('sets map zoom level and center', function() {
//            expect(args[1].zoom).toEqual(jasmine.any(Number));
//            expect(args[1].center).toEqual(coordinates_mock)
//        });
//        it('displays the map in the given div', function() {
//            expect(args[0].id).toEqual('map-canvas')
//        })
//    });
//
//    describe('loadMarker()', function() {
//        beforeEach(function() {
//            script.loadMarker(script.loadMap(), org)
//        });
//        it('sets marker position', function() {
//            var args = coordinates_stub.calls.mostRecent().args;
//            expect(args).toEqual(['51.5000000', '-0.5000000'])
//        });
//        it('sets marker name for popover on hover', function() {
//            var args = marker_stub.calls.mostRecent().args[0];
//            expect(args.title).toEqual('sample organization')
//        });
//        it('sets HTML for marker info window contents', function() {
//            var args = infowindow_stub.calls.mostRecent().args[0];
//            expect(args.content).toEqual('<a href="/organizations/1">sample organization</a><br>I am a unique snowflake');
//        });
//    });

    describe('clicking on a marker', function() {
        var marker;
        beforeEach(function() {
//            marker_stub.and.callThrough();
//            infowindow_stub.and.callThrough();
            marker = script.loadMarker(script.loadMap(), org)
        });
        it('closes the previously-open info window', function() {
            LocalSupport.maps.openInfoWindow = infowindow_mock;
            google.maps.event.trigger(marker, 'click');
            expect(infowindow_mock.close).toHaveBeenCalled()
        })
    })

});

