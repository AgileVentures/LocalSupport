class BaseOrganisationsController < ApplicationController
  def build_map_markers(organisations)
    ::MapMarkerJson.build(organisations) do |org, marker|
      marker.lat org.latitude
      marker.lng org.longitude
      marker.infowindow render_to_string(partial: 'organisations/popup', locals: {org: org})
      marker.json(
        custom_marker: render_to_string(
          partial: 'shared/custom_marker',
          locals: { attrs: org.gmaps4rails_marker_attrs }
        ),
        index: org.recently_updated_and_has_owner ? 1 : -1,
        type:  org.recently_updated_and_has_owner ? 'large_org' : 'small_org'
      )
    end
  end

end
