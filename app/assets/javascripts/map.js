LocalSupport.google_map = {
  settings: {
    id: 'map_canvas',
    zoom: 12,
    lat: 51.5978,
    lng: -0.3370,
  },
  parsed_settings: function(google, hash) {
    return {
      internal: {id: hash.id},
      provider: {
        zoom: hash.zoom,
        center: new google.maps.LatLng(hash.lat, hash.lng),
      }
    }
  },
  marker_data: function() {
    return $('#marker_data').data().markers;
  },
  build: function(settings, data) {
    var handler = Gmaps.build('Google');
    handler.buildMap(settings, function() {
      var markers = handler.addMarkers(data);
      _.each(markers, function(marker) {
        if (marker.serviceObject.shadow != null) {
          marker.serviceObject.setZIndex(0);
        } else {
          marker.serviceObject.setZIndex(1);
        }
      })
      handler.bounds.extendWith(markers);
    })
  }
}
$(function(){
  var map = LocalSupport.google_map;
  var settings = map.parsed_settings(google, map.settings);
  map.build(settings, map.marker_data());
});
