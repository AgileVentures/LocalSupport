LocalSupport.maps = {
    data: undefined, // View must provide this array of json hashes (e.g. raw @organizations.to_json)
    openInfoWindow: undefined, // Used to track currently open info window
    loadMap: function() {
        var harrow = new google.maps.LatLng(51.590000,-0.280000);
        var mapOptions = {
            zoom: 13,
            center: harrow
        };
        return new google.maps.Map(document.getElementById('map'), mapOptions);
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
    var that = LocalSupport.maps;
    var map = that.loadMap();
    that.data.forEach(function(org) {
        that.loadMarker(map, org)
    });
});