//= require gmaps/google
//= require gmaps-markerclusterer-plus/src/markerclusterer
//= require js-rich-marker/src/richmarker
//= require google-infobox/google-infobox
//= require google_map/marker_builder
//= require google_map/map_settings

LocalSupport.GoogleMap = ->
  marker_data = $("#marker_data").data().markers

  handler = Gmaps.build("Google", builders: { Marker: LocalSupport.MarkerBuilder })

  build: (settings) ->
    handler.buildMap settings, ->
      markers = _.map marker_data, (marker_datum) =>
        handler.addMarker
          lat: marker_datum.lat
          lng: marker_datum.lng
          custom_marker: marker_datum.custom_marker
          custom_infowindow: marker_datum.infowindow
          index: marker_datum.index
      handler.bounds.extendWith markers

$ ->
  settings = LocalSupport.MapSettings().for google
  LocalSupport.GoogleMap().build settings
