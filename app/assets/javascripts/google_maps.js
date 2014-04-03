LocalSupport.maps = {
    data: undefined, // View must provide this array of json hashes (e.g. raw @organizations.to_json)
    openInfoWindow: undefined, // Used to track currently open info window
    loadMap: function() {
        var harrow = new google.maps.LatLng(51.5978, -0.3370);
        var mapOptions = {
            zoom: 12,
            center: harrow
        };
        return new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
    },
    loadMarker: function(map, org) {
        var coords = new google.maps.LatLng(org.latitude, org.longitude);
        var marker = new google.maps.Marker({
            position: coords,
            title: org.name,
            infoWindow: new google.maps.InfoWindow({
                content: '<a href="/organizations/' + org.id + '">' + org.name + '</a><br>' + org.description,
                position: coords,
                disableAutoPan: true
            })
        });
        google.maps.event.addListener(marker, 'click', function() {
            // this == marker
            var previous = LocalSupport.maps.openInfoWindow;
            if (previous != undefined) {
                previous.close()
            }
            this.infoWindow.open(map, this);
            LocalSupport.maps.openInfoWindow = this.infoWindow
        });
        marker.setMap(map)
    }
};

$(function () {
    hander = Gmaps.build('Google');
    handler.buildMap
    var that = LocalSupport.maps;
    var map = that.loadMap();
    that.data.forEach(function(org) {
        that.loadMarker(map, org)
    });
});

