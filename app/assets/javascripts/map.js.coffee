class LocalSupport.MarkerBuilder extends Gmaps.Google.Builders.Marker
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

LocalSupport.MapSettings = ->
  settings =
    id: "map_canvas"
    zoom: 12
    lat: 51.5978
    lng: -0.3370

  for: (provider) ->
    internal:
      id: settings.id
    provider:
      zoom: settings.zoom
      center: new provider.maps.LatLng(settings.lat, settings.lng)

LocalSupport.GoogleMap = ->
  marker_data = $("#marker_data").data().markers

  build: (settings) ->
    handler = Gmaps.build("Google", builders: { Marker: LocalSupport.MarkerBuilder })
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
