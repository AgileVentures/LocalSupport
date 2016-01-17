module MapMarkerJson
  def self.build(organisations)
    Gmaps4rails.build_markers(organisations) do |org, marker|
      yield org.as_json, marker
    end.select do |marker|
      marker[:lat].present? && marker[:lng].present?
    end.to_json
  end
end
