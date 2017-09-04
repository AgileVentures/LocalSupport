//= require google-infobox/google-infobox
//= require google_maps/custom_marker

var map;
var openedInfoBox = null;
var markers = [];
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
    pixelOffset: new google.maps.Size(-140, 10)
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
        openedInfoBox = ib;
        ib.setOptions(ibOptions);
        boxText.innerHTML = item.infowindow;
        $(ib.content_).find('.close').click(function(){
          ib.close();
          openedInfoBox = null;
        });
        ib.open(map, this);
        map.panTo(ib.getPosition());
    });
    
    markers.push(marker);
  });
}

function centerMap(coordinates) {
  map.setCenter({ lat: coordinates['lat'], lng: coordinates['lng'] });
}

function closeInfoBox() {
  if (openedInfoBox !== null)
    openedInfoBox.close();
}

function getVolOpCoordinates (volop) {
  return {
    lat: parseFloat($(volop).attr('data-lat')),
    lng: parseFloat($(volop).attr('data-lng'))
  };
}

function openInfoBox(coordinates) {
  $.each(markers, function(key, value) {
    if (value.latlng.lat().toFixed(6) === coordinates['lat'].toFixed(6) 
        && value.latlng.lng().toFixed(6) === coordinates['lng'].toFixed(6))
      google.maps.event.trigger(value, 'click');
  });
}

google.maps.event.addDomListener(window, "load", initMap);

var debouceOpenInfoBox = _.debounce(function(volop) {
    if ($(volop).attr('data-lat') !== '' && $(volop).attr('data-lng') !== '') {
      centerMap(getVolOpCoordinates(volop));
      openInfoBox(getVolOpCoordinates(volop));
    }
}, 300);

$(document).ready(function() {
  if (($('#content').height() - 14) >= 400) {
    $('#map-canvas').height($('#content').height() - 14);
  }

  $('.center-map-on-op').mouseenter(function () {
    debouceOpenInfoBox(this);
  })
  .mouseleave(function() {
    closeInfoBox();
  });
});
