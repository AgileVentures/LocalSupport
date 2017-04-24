//= require google-infobox/google-infobox
//= require google_maps/custom_marker

var map;
var markers = [];
var items = [];
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

  var ib = createInfoBox();

  markerData.forEach(function(item) {  
    var latLng = new google.maps.LatLng(item.lat, item.lng);
    marker = new CustomMarker(latLng, map, { content: item.custom_marker });
    
    google.maps.event.addListener(marker, 'click', function() {
      setInfoBoxInnerContent(ib, item.infowindow);
      ib['infoBox'].open(map, this);
      map.panTo(ib['infoBox'].getPosition());
    });
    
    markers.push(marker);
    items.push(item);
  });
}

function centerMap(lat, lng) {
  map.setCenter({ lat: lat, lng: lng });
  map.setZoom(15);
}

function createInfoBox() {
  var ib = new InfoBox(),
  ibOptions = { pixelOffset: new google.maps.Size(-151, 10) }, 
  boxText = document.createElement("div");
  
  boxText.setAttribute("class", "arrow_box")
  ibOptions.content = boxText;
  ib.setOptions(ibOptions);
  
  return { infoBox: ib, infoBoxOptions: ibOptions, infoBoxText: boxText };
}

function openInfoBox(lat, lng) {
  var ib = createInfoBox();
  
  markers.forEach(function(item) {
    var posn = item.getPosition();
    if (posn.lat() == lat && posn.lng().toFixed(6) == lng.toFixed(6)) {
      items.forEach(function(i) {
        if (i.lat == lat && i.lng == lng)
          setInfoBoxInnerContent(ib, i.infowindow);
      })
      ib['infoBox'].open(map, item);
    }
  });
}

function setInfoBoxInnerContent(ib, info) {
  ib['infoBoxText'].innerHTML = info;
  $(ib['infoBox'].content_).find('.close').click(function(){ 
    ib['infoBox'].close();
  });
}

google.maps.event.addDomListener(window, "load", initMap);

$(document).ready(function() {
  if (($('#content').height() - 14) >= 400) {
    $('#map-canvas').height($('#content').height() - 14);
  }
  
  $('.organisation-title').click(function () {
    var lat = parseFloat($(this).attr('data-lat')),
    lng = parseFloat($(this).attr('data-lng'));
    
    centerMap(lat, lng);
    openInfoBox(lat, lng);
  });
});