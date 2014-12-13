window.InfoWindowBuilderFactory = {}

InfoWindowBuilderFactory.fetchBuilder = (type) ->
  switch type
    when 'vol_op' then {
      infobox: (boxText)->
        content: boxText
        pixelOffset: new google.maps.Size(-151,10)
      klass: ->
        "arrow_box_vol_op"
    }
    when 'small_org' then {
      infobox: (boxText)->
        content: boxText
        pixelOffset: new google.maps.Size(-151,-84)
      klass: ->
        "arrow_box"
    }
    when 'large_org' then {
      infobox: (boxText)->
        content: boxText
        pixelOffset: new google.maps.Size(-151,-102)
      klass: ->
        "arrow_box"
    }

class LocalSupport.MarkerBuilder extends Gmaps.Google.Builders.Marker

  create_marker: ->
    @infoWindowBuilder = InfoWindowBuilderFactory.fetchBuilder this.args.type
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
    boxText.setAttribute("class", @infoWindowBuilder.klass())
    boxText.innerHTML = @args.custom_infowindow
    @infowindow = new InfoBox(@infobox(boxText))
    @addCloseHandler(@infowindow)


  addCloseHandler: (infowindow) ->
    $(infowindow.content_).find('.close').click(->
      infowindow.close()
    )
    infowindow

  infobox: (boxText)->
    @infoWindowBuilder.infobox boxText 
