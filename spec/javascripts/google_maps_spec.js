describe('Interaction with Google Maps API', function () {
    var marker, mapStub, mapMock, script, org;

    beforeEach(function () {
        jasmine.addMatchers({
            toBeInstanceOf: function() {
                return {
                    compare: function(actual, expected) {
                        var result = {
                            pass: actual instanceof expected
                        };
                        var notText = result.pass ? "" : " not";
                        result.message = "Expected " + actual.constructor.name + notText + " is instance of " + expected.name;
                        return result
                    }
                }
            }
        });

        setFixtures(sandbox({ id: 'map-canvas' }));

        mapMock = jasmine.createSpy('Map');

        org = {
            id: '1',
            name: 'sample organization',
            description: 'I am a unique snowflake',
            latitude: '51.5000000',
            longitude: '-0.5000000'
        };
        script = LocalSupport.maps;
        script.data = [ org ];

        marker = script.createMarker(org);
    });

    describe('loadMap()', function() {
        var args;
        beforeEach(function() {
            mapStub = spyOn(google.maps, 'Map');
            script.loadMap();
            args = mapStub.calls.mostRecent().args
        });
        it('sets map zoom level and center', function() {
            expect(args[1].zoom).toEqual(jasmine.any(Number));
            expect(args[1].center).toBeInstanceOf(google.maps.LatLng)
        });
        it('anchors the map in the given div', function() {
            expect(args[0].id).toEqual('map-canvas')
        })
    });

    describe('createMarker()', function() {
        var markerStub, markerArgs, infoWindowStub, infoWindowArgs;
        beforeEach(function() {
            markerStub = spyOn(google.maps, 'Marker');
            infoWindowStub = spyOn(google.maps, 'InfoWindow');
            marker = script.createMarker(org);
            markerArgs = markerStub.calls.mostRecent().args[0];
            infoWindowArgs = infoWindowStub.calls.mostRecent().args[0]
        });
        it('sets marker position', function() {
            expect(markerArgs.position).toBeInstanceOf(google.maps.LatLng)
        });
        it('sets marker title', function() {
            expect(markerArgs.title).toEqual(org.name)
        });
        it('sets marker info window', function() {
            expect(markerArgs.infoWindow).toBeInstanceOf(google.maps.InfoWindow)
        });
        describe('info window', function() {
            it('content based on organization', function() {
                expect(infoWindowArgs.content).toEqual('<a href="/organizations/1">sample organization</a><br>I am a unique snowflake')
            });
            it('shares the same coordinates as the marker', function() {
                expect(markerArgs.position).toEqual(infoWindowArgs.position)
            });
            it('does not pan the map when clicked', function() {
                expect(infoWindowArgs).toBeTruthy()
            })
        });
    });

    describe('placeMarker()', function() {
        var setMap, addListener;
        beforeEach(function() {
            marker = script.createMarker(org);
            setMap = spyOn(marker, 'setMap');
            addListener = spyOn(google.maps.event, 'addListener');
            script.placeMarker(marker, mapMock)
        });
        it('sets marker click behavior', function() {
            expect(addListener).toHaveBeenCalled();
            var args = addListener.calls.mostRecent().args;
            expect(args[0]).toEqual(marker);
            expect(args[1]).toEqual('click');
            expect(args[2]).toEqual(jasmine.any(Function))
        });
        it('adds the marker to the map', function() {
            expect(setMap).toHaveBeenCalledWith(mapMock)
        })
    });

    describe('clicking on a marker', function() {
        beforeEach(function() {
            spyOn(marker, 'setMap');
            script.placeMarker(marker, mapMock)
        });
        it('opens an info window', function() {
            var open = spyOn(marker.infoWindow, 'open');
            google.maps.event.trigger(marker, 'click');
            expect(open).toHaveBeenCalled()
        });
        it('closes the previously-open info window', function() {
            var infowindowMock = jasmine.createSpyObj('InfoWindow', ['open', 'close']);
            LocalSupport.maps.openInfoWindow = infowindowMock;
            google.maps.event.trigger(marker, 'click');
            expect(infowindowMock.close).toHaveBeenCalled()
        })
    });
});

