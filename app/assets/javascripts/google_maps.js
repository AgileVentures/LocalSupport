LocalSupport.maps = {
    data: undefined, // View must provide this array of json hashes (e.g. raw @organizations.to_json)
    openInfoWindow: undefined, // Used to track currently open info window
    initialize: function() {
        var script = LocalSupport.maps;
        var map = script.loadMap();
        script.data.forEach(function(org) {
            var marker = script.createMarker(org);
            script.placeMarker(marker, map)
        });
    },
    loadMap: function() {
        var harrow = new google.maps.LatLng(51.5978, -0.3370);
        var mapOptions = {
            zoom: 12,
            center: harrow
        };
        return new google.maps.Map(document.getElementById('map-canvas'), mapOptions);      // calls to google servers
    },
    createMarker: function(org) {
        var coords = new google.maps.LatLng(org.latitude, org.longitude);
        return new google.maps.Marker({
            position: coords,
            title: org.name,
            infoWindow: new google.maps.InfoWindow({
                content: '<a href="/organizations/' + org.id + '">' + org.name + '</a><br>' + org.description,
                position: coords,
                disableAutoPan: true
            })
        });
    },
    placeMarker: function(marker, map) {
        google.maps.event.addListener(marker, 'click', function() {
            // this == marker
            var previous = LocalSupport.maps.openInfoWindow;
            if (previous != undefined) {
                previous.close()
            }
            this.infoWindow.open(map, this);
            LocalSupport.maps.openInfoWindow = this.infoWindow
        });
        marker.setMap(map);
    }
};

$(function () {
    var script = LocalSupport.maps;
    var map = script.loadMap();
    $.each(script.data, function (_, org) {
        var marker = script.createMarker(org);
        script.placeMarker(marker, map)
    });
});

