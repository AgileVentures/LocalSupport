module MapMarkerJson
  def self.build(organisations)
    Gmaps4rails.build_markers(Queries::Organisations.add_recently_updated_and_has_owner(organisations)) do |org, marker|
      yield org, marker
    end.select do |marker|
      marker[:lat].present? && marker[:lng].present?
    end.to_json
  end
end
