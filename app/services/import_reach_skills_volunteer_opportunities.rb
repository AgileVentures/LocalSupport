require 'geocoder'

class ImportReachSkillsVolunteerOpportunities

  def self.with(http = HTTParty, model_klass = VolunteerOp)
    new(http, model_klass).send(:run)
  end

  private

  attr_reader :http, :model_klass

  def initialize(http, model_klass)
    @http = http
    @model_klass = model_klass
  end

  def run
    href = 'https://reachskills.org.uk/harrow-community-network-opportunity-feed'
    model_klass.delete_all(source: 'reachskills')
    while href = process_reach_skills_json_page(http.get("#{href}"));
    end
  end

  def process_reach_skills_json_page(response)
    return nil unless has_content?(response)
    opportunities = JSON.parse(response.body)['nodes']
    persist_reach_skills_vol_ops(opportunities)
    nil
  end

  def persist_reach_skills_vol_ops(opportunities)
    opportunities.each do |op|
      coordinates = Geocoder.search(
        "#{op['node']['Postcode']}, #{op['node']['Town']}"
      ).first

      model_klass.create(
        source: 'reachskills',
        latitude: coordinates ? coordinates.latitude.to_f : 0.0,
        longitude: coordinates ? coordinates.longitude.to_f : 0.0,
        title: op['node']['title'],
        description: op['node']['Description'],
        reachskills_org_name: op['node']['Organisation'],
        reachskills_org_link: op['node']['Path']
      )
    end
  end

  def has_content?(response)
    response.body && response.body != '[]'
  end

end
