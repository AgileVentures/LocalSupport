$(function () {
  var handler = Gmaps.build('Google');
  handler.buildMap({
    internal: {id: 'map_canvas'},
    provider: {
      minZoom: 12,
      center: new google.maps.LatLng(51.5978, -0.3370),
      auto_adjust: false,
    }
    }, function(){
    var marker_data = $('#marker_data').data().markers;
    var markers = handler.addMarkers(marker_data);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
  });
});
