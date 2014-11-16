$(function () {
  var handler = Gmaps.build('Google');
  handler.buildMap({ internal: {id: 'map_canvas'} }, function(){
    var marker_data = $('#marker_data').data().markers;
    var markers = handler.addMarkers(marker_data);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
    handler.getMap().setZoom(12);
    handler.getMap().setZoom(new google.maps.LatLng(51.5978, -0.3370));
  });
});
