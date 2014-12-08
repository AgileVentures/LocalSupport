class LocalSupport.MarkerBuilder extends Gmaps.Google.Builders.Marker
  create_marker: ->
    @type = this.args.index
    this.args.index = switch this.args.index
      when 'small_org' then -1
      when 'large_org', 'vol_op' then 1
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
    offset = switch @type
      when 'large_org' then new google.maps.Size(-151, -102)
      when 'small_org' then new google.maps.Size(-151, -84)
      when 'vol_op' then new google.maps.Size(-151,-157)
    content: boxText
    pixelOffset: offset
