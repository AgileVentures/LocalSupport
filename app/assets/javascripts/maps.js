//= require google-infobox/google-infobox
//= require google_maps/custom_marker

var map;
var Settings = {
  id: 'map-canvas',
  lat: 51.5978,
  lng: -0.3370,
  zoom: 12
};

function initMap() {

  map = new google.maps.Map(document.getElementById(Settings.id), {
    center: {lat: Settings.lat, lng: Settings.lng},
    zoom: Settings.zoom
  });

  var markerData = $("#marker_data").data().markers;

  var marker;

  var ib = new InfoBox();
  var ibOptions = {
    pixelOffset: new google.maps.Size(-151, 10)
  };

  var boxText = document.createElement("div");
  boxText.setAttribute("class", "arrow_box")
  ibOptions.content = boxText;

  markerData.forEach(function(item) {  
    var latLng = new google.maps.LatLng(item.lat, item.lng);

    marker = new CustomMarker(
        latLng,
        map,
        {
          content: item.custom_marker
        }
        );

    google.maps.event.addListener(marker, 'click', function() {
        ib.setOptions(ibOptions);
        boxText.innerHTML = item.infowindow;
        $(ib.content_).find('.close').click(function(){
          ib.close();
        });
        ib.open(map, this);
        map.panTo(ib.getPosition());
    }); 

  });
};

function centerMap(lat, lng) {
  map.setCenter({ lat: lat, lng: lng });
};

google.maps.event.addDomListener(window, "load", initMap);

$(document).ready(function() {
  if (($('#content').height() - 14) >= 400) {
    $('#map-canvas').height($('#content').height() - 14);
  }
  
  $('.center-map-on-op').mouseover(function () {
    var lat = parseFloat($(this).attr('data-lat')),
    lng = parseFloat($(this).attr('data-lng'));
    
    centerMap(lat, lng);
  });
});