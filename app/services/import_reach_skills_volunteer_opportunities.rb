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
    model.source = 'reachskills'
    model.latitude = coordinates ? coordinates.latitude.to_f : 0.0
    model.longitude = coordinates ? coordinates.longitude.to_f : 0.0
    model.title = op['node']['title']
    model.description = op['node']['Description']
    model.reachskills_org_name = op['node']['Organisation']
    model.reachskills_op_link = op['node']['Path']
  end
end
