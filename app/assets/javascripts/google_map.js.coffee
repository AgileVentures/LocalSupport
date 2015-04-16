//= require gmaps/google
//= require gmaps-markerclusterer-plus/src/markerclusterer
//= require js-rich-marker/src/richmarker
//= require google-infobox/google-infobox
//= require google_map/marker_builder
//= require google_map/map_settings

class LocalSupport.GoogleMap
  container_padding: 6 * 2

  marker_data: ->
    $("#marker_data").data().markers

  handler: ->
    Gmaps.build("Google", builders: { Marker: LocalSupport.MarkerBuilder })

  build: (settings) ->
    handler = @handler()
    handler.buildMap settings, =>
      markers = _.map @marker_data(), (marker_datum) =>
        handler.addMarker
          lat: marker_datum.lat
          lng: marker_datum.lng
          custom_marker: marker_datum.custom_marker
          custom_infowindow: marker_datum.infowindow
          index: marker_datum.index
          type: marker_datum.type
      handler.bounds.extendWith markers

$ ->
  settings = LocalSupport.MapSettings().for google
  map = new LocalSupport.GoogleMap()
  height = if (400 > ($('#content').height() - map.container_padding)) then 400 else ($('#content').height() - map.container_padding)
  $('#map_canvas').height(height)
  map.build settings
