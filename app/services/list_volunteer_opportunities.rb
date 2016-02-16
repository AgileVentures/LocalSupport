# Lists Volunteer Opportunities; at the moment this service is creating a list of organisations each with a
# volunteer opportunity and returning them along with a set of markers that can be used to display those organizations
# on a google map.  Those markers are merged with other markers generated from the the list of
# organisations in our local database that have volunteers.

# This means the title of the service is somewhat misleading, although it is used in the Volunteer Ops controller.  To
# properly follow our CRUD services model this service should be titled ListOrganisationsWithVolunteers, or
# ListOrganisations and take a parameter to indicate we want to list Organisations that have associated volunteer
# opportunities.  It even implies that the Volunteer Op view should arguably be loaded from the OrganisationsController

# As it stands the current code in this service is mainly concerned with processing one or more pages of JSON data from
# the doit API and transforming that into an array of OpenStructs that can be handled by the current view. The code
# also calls back to the controller to create the necessary google map markers and merge the two sets together; handling
# cases where one or other might be missing
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

  HOST = 'https://api.do-it.org'
  HREF = '/v1/opportunities?lat=51.5978&lng=-0.3370&miles=0.5'

  def run
    harrow_markers = listener.build_map_markers(organisations)
    return [harrow_markers, []] unless feature.active? :doit_volunteer_opportunities
    doit_orgs = get_doit_orgs_for_multiple_pages_of_json
    doit_markers = listener.build_map_markers(doit_orgs, :doit, false)
    markers = merge_json_markers(harrow_markers, doit_markers)
    [markers, doit_orgs]
  end

  def get_doit_orgs_for_multiple_pages_of_json
    href = HREF
    doit_orgs = []
    while href = process_one_page_of_doit_json(http_party.get("#{HOST}#{href}"), doit_orgs); end
    doit_orgs
  end

  def process_one_page_of_doit_json(response, doit_orgs)
    return nil unless has_content?(response)
    opportunities = JSON.parse(response.body)['data']['items']
    create_doit_orgs_from_opportunities(doit_orgs, opportunities)
    JSON.parse(response.body)['links'].fetch('next', {'href' => nil})['href']
  end

  def has_content?(response)
    response.body && response.body != '[]'
  end

  def create_doit_orgs_from_opportunities(doit_orgs, opportunities, id=1)
    opportunities.each do |item|
      doit_orgs.push(OpenStruct.new(latitude: item['lat'], longitude: item['lng'],
                                    opp_name: item['title'], id: id,
                                    description: item['description'],
                                    opportunity_id: item['id'],
                                    name: item['for_recruiter']['name'],
                                    org_link: item['for_recruiter']['slug']))
      id += 1
    end
  end

  def merge_json_markers(harrow_markers, doit_markers)
    return doit_markers if harrow_markers == '[]'
    return harrow_markers if doit_markers == '[]'
    harrow_markers[0...-1]+', ' + doit_markers[1..-1]
  end

end