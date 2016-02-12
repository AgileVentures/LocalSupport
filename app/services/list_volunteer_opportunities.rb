class ListVolunteerOpportunities

  def self.with(listener, organisations, feature = Feature, http_party = HTTParty)
    new(listener, organisations, feature, http_party).send(:run)
  end

  private

  attr_reader :organisations, :listener, :feature, :http_party

  def initialize(listener, organisations, feature, http_party)
    @listener = listener
    @organisations = organisations
    @feature = feature
    @http_party = http_party
  end

  def run
    harrow_markers = listener.build_map_markers(organisations)
    return [harrow_markers, []] unless feature.active? :doit_volunteer_opportunities
    doit_orgs = get_doit_orgs
    doit_markers = listener.build_map_markers(doit_orgs, :doit, false)
    markers = merge_json_markers(harrow_markers, doit_markers)
    [markers, doit_orgs]
  end

	def get_doit_orgs
		host = 'https://api.do-it.org'
    href = "/v1/opportunities\?lat\=51.5978\&lng\=-0.3370\&miles\=0.5 "
    doit_orgs = [] 
    while href
      url = host + href
      response = http_party.get(url)
      if response.body && response.body != '[]'
        opportunities = JSON.parse(response.body)['data']['items']
        get_doit_orgs_from_one_page(doit_orgs, opportunities)
        next_page = JSON.parse(response.body)['links']['next']
      end
      href = next_page ? next_page['href'] : nil
    end
    doit_orgs
  end

  def get_doit_orgs_from_one_page(doit_orgs, opportunities, id=1)
    opportunities.each do |item|
      org = OpenStruct.new(latitude: item['lat'], longitude: item['lng'], 
            opp_name: item['title'], id: id, 
            description: item['description'], 
            opportunity_id: item['id'], 
            name: item['for_recruiter']['name'], 
            org_link: item['for_recruiter']['slug'])
      doit_orgs.push (org)
      id += 1
    end
  end

  def merge_json_markers(harrow_markers, doit_markers)
    return doit_markers if harrow_markers == '[]'
    return harrow_markers if doit_markers == '[]'
    harrow_markers[0...-1]+', ' + doit_markers[1..-1]
  end

end