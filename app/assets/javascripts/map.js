g = 
  function (handler) {
    return function(){
      handler.buildMap({ internal: {id: 'map_canvas'},
      provider: {
        zoom: 12,
        center: new google.maps.LatLng(51.5978, -0.3370),
      }}, function(){
      var marker_data = $('#marker_data').data().markers;
      var markers = handler.addMarkers(marker_data);
      handler.bounds.extendWith(markers);
    });
    }
  }

var handler = Gmaps.build('Google');
//$(g(handler));
