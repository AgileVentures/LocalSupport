LocalSupport.InfoWindowBuilderFactory = (provider) ->
  fetchBuilder: (type)->
    switch type
      when 'vol_op' then {
        infobox: (boxText)->
          content: boxText
          pixelOffset: new provider.maps.Size(-151,10)
        klass: ->
          "arrow_box_vol_op"
      }
      when 'small_org' then {
        infobox: (boxText)->
          content: boxText
          pixelOffset: new provider.maps.Size(-151,-84)
        klass: ->
          "arrow_box"
      }
      when 'large_org' then {
        infobox: (boxText)->
          content: boxText
          pixelOffset: new provider.maps.Size(-151,-102)
        klass: ->
          "arrow_box"
      }
