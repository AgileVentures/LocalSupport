LocalSupport.InfoWindowBuilderFactory = (provider, type) ->
  switch type
    when 'vol_op' then {
    infobox: (boxText)->
      content: boxText
      pixelOffset: new provider.maps.Size(-151, 10)
    }
    when 'small_org' then {
      infobox: (boxText)->
        content: boxText
        pixelOffset: new provider.maps.Size(-151, 5)
    }
    when 'large_org' then {
      infobox: (boxText)->
        content: boxText
        pixelOffset: new provider.maps.Size(-151, 10)
    }