LocalSupport.google_map =
  settings:
    id: "map_canvas"
    zoom: 12
    lat: 51.5978
    lng: -0.3370

  parsed_settings: (google, hash) ->
    internal:
      id: hash.id

    provider:
      zoom: hash.zoom
      center: new google.maps.LatLng(hash.lat, hash.lng)

  marker_data: ->
    $("#marker_data").data().markers

  build: (settings, data) ->
    handler = Gmaps.build("Google")
    handler.buildMap settings, ->
      markers = handler.addMarkers(data)
      _.each markers, (marker) ->
        marker.serviceObject.setZIndex if marker.serviceObject.shadow? then 0 else 1
      handler.bounds.extendWith markers

$ ->
  if typeof google isnt "undefined"
    map = LocalSupport.google_map
    settings = map.parsed_settings(google, map.settings)
    map.build settings, map.marker_data()
