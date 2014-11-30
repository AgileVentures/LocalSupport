class CustomMarkerBuilder extends Gmaps.Google.Builders.Marker
  create_marker: ->
    options = _.extend @marker_options(), @rich_marker_options()
    @serviceObject = new RichMarker options

  rich_marker_options: ->
    marker = document.createElement("div")
    marker.setAttribute('class', 'custom_marker_content')
    marker.innerHTML = this.args.custom_marker
    {
      content: marker
      flat: true
      zIndex: this.args.index
    }

  create_infowindow: ->
    return null unless _.isString @args.custom_infowindow

    boxText = document.createElement("div")
    boxText.setAttribute("class", 'arrow_box')
    boxText.innerHTML = @args.custom_infowindow
    @infowindow = new InfoBox(@infobox(boxText))
    @addCloseHandler(@infowindow)


  addCloseHandler: (infowindow) ->
    $(infowindow.content_).find('.close').click(->
      infowindow.close()
    )
    infowindow

  infobox: (boxText)->
    content: boxText
    pixelOffset: new google.maps.Size(-150, 10)

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
    handler = Gmaps.build("Google", builders: { Marker: CustomMarkerBuilder })
    handler.buildMap settings, ->
      markers = _.map data, (marker_data) =>
        handler.addMarker
          lat: marker_data.lat
          lng: marker_data.lng
          custom_marker: marker_data.custom_marker
          custom_infowindow: marker_data.infowindow
          index: marker_data.index
      # markers = handler.addMarkers(data)
      # _.each markers, (marker) ->
      #   marker.serviceObject.setZIndex if marker.serviceObject.shadow? then 0 else 1
      handler.bounds.extendWith markers

$ ->
  if typeof google isnt "undefined"
    map = LocalSupport.google_map
    settings = map.parsed_settings(google, map.settings)
    map.build settings, map.marker_data()
