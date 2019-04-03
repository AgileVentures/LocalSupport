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
    href = 'https://reachvolunteering.org.uk/harrow-community-network-opportunity-feed'
    model_klass.where(source: 'reachskills').delete_all
    process_reach_skills_json_page(http.get(href))
  end

  def process_reach_skills_json_page(response)
    return nil unless content?(response)
    opportunities = JSON.parse(response.body)['nodes']
    persist_reach_skills_vol_ops(opportunities)
    nil
  end

  def persist_reach_skills_vol_ops(opportunities)
    opportunities.each do |op|
      create_or_update_reach_skills_vol_ops(op, find_coordinates(op))
    end
  end

  def create_or_update_reach_skills_vol_ops(op, coordinates)
    model_klass.find_or_create_by(reachskills_op_link: op['node']['Path']) do |model|
      populate_vol_op_attributes(op, model, coordinates)
    end
  end

  def content?(response)
    response.body && response.body != '[]'
  end

  def find_coordinates(op)
    Geocoder.search(
      "#{op['node']['Postcode']}, #{op['node']['Town']}"
    ).first
  end

  def populate_vol_op_attributes(op, model, coordinates)
    location = Location.create coordinates
    model.source = 'reachskills'
    model.latitude  = location.latitude
    model.longitude = location.longitude
    model.title = op['node']['title']
    model.description = op['node']['Description']
    model.reachskills_org_name = op['node']['Organisation']
    model.reachskills_op_link = op['node']['Path']
    one_day_ago = Time.current - 1.day # necessary until api is updated.
    model.updated_at = one_day_ago # https://www.pivotaltracker.com/story/show/153805125
    model.created_at = one_day_ago
    model.imported_at   = Time.current
  end
end
