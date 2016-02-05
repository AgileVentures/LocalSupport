class VolunteerOpMarkerBuilder
  def initialize(organisations, listener, marker_builder, url_helper)
    @organisations = organisations
    @marker_builder = marker_builder
    @listener = listener
    @url_helper = url_helper
  end

  def perform
    marker_builder.build(organisations) do |org, marker|
      marker.lat org.latitude
      marker.lng org.longitude
      marker.infowindow listener.render_to_string(partial: 'popup', locals: { org: org })
      marker.json(
        custom_marker: listener.render_to_string(
          partial: 'shared/custom_marker',
          locals: {
            attrs: [
              url_helper.asset_path("volunteer_icon.png"),
              {
                'data-id' => org.id,
                'class'   => 'vol_op',
                'title'   => "Click here to see volunteer opportunities at #{org.name}"
              }
            ]
          }
        ),
        index: 1,
        type: 'vol_op'
      )
    end
  end

  private

  attr_reader :organisations,
    :marker_builder,
    :listener,
    :url_helper
end
