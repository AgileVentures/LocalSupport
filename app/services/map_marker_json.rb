module MapMarkerJson
  def self.build(orgs, include_extra_organisation_data = true)
    orgs = organisations_with_extra_data(orgs) if include_extra_organisation_data
    Gmaps4rails.build_markers(orgs) { |*args| yield *args }
      .select { |marker| lat_lng_present?(marker) }.to_json
  end

  private

  def self.organisations_with_extra_data(organisations)
    Queries::Organisations.add_recently_updated_and_has_owner(organisations)
  end

  def self.lat_lng_present?(marker)
    marker[:lat].present? && marker[:lng].present?
  end

end
