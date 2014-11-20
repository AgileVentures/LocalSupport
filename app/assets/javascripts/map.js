LocalSupport.google_map = {
  element: '#marker_data',
  settings: {
    id: 'map_canvas',
    zoom: 12,
    lat: 51.5978,
    lng: -0.3370,
  },
  parse_settings: function(google, hash) {
    return {
      internal: {id: hash.id},
      provider: {
        zoom: hash.zoom,
        center: new google.maps.LatLng(hash.lat, hash.lng),
      }
    }
  },
  build: function(el, settings) {
    var handler = Gmaps.build('Google');
    handler.buildMap(settings, function() {
      var marker_data = $(el).data().markers;
      var markers = handler.addMarkers(marker_data);
      handler.bounds.extendWith(markers);
    })
  }
}
$(function(){
  var map = LocalSupport.google_map;
  var settings = map.parse_settings(google, map.settings);
  map.build(map.element, settings);
});
