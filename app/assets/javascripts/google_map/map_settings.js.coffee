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

