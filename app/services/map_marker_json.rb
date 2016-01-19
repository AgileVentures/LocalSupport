module MapMarkerJson
  def self.build(organisations, include_extra_organisation_data = true)
    if include_extra_organisation_data
      organisations = Queries::Organisations.add_recently_updated_and_has_owner(organisations)
    end
    Gmaps4rails.build_markers(organisations) do |org, marker|
      yield org, marker
    end.select do |marker|
      marker[:lat].present? && marker[:lng].present?
    end.to_json
  end

end
