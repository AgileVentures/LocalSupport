Then(/^I should see an infowindow when I click on the map (measle|pin|event|vol_op) markers:$/) do |klass, table|
  klass_hash = {'measle' => '.measle', 'vol_op' => '.vol_op', 'event' => '.vol_op', 'pin' => '.marker'}
  check_for_org_info_box(table.raw.flatten, klass_hash[klass])
end

Then(/^I should see an infowindow when I click on the (?:.*) map markers:$/) do |table|
  check_for_volop_info_box(table.raw.flatten, '.vol_op')
end

Then(/^I should open opportunity in a new windows when clicked from the infowindow:$/) do |table|
  check_info_box_link_opens_in_new_page(table.raw.flatten, '.vol_op')
end

Then (/^I should see an infowindow when mouse enters volop in table:$/) do |table|
  check_for_volop_info_box(table.raw.flatten, '.center-map-on-op')
end

Then (/^I shouldn't see an infowindow when mouse enters volop in table:$/) do |table|
  check_for_no_org_info_box(table.raw.flatten, '.center-map-on-op')
end

Then (/^I should see an infowindow when mouse enters volop with long and lat in table:$/) do |table|
  check_for_volop_info_box(table.raw.flatten, '.center-map-on-op', false)
end

Then (/^I shouldn't see an infowindow when mouse enters volop without long and lat in table:$/) do |table|
  check_for_no_org_info_box(table.raw.flatten, '.center-map-on-op', false)
end

Then (/^I should not see an infowindow when mouse leaves volop in table:$/) do |table|
  check_for_no_org_info_box(table.raw.flatten, '.center-map-on-op')
end

Then (/^I should only see the map container element on the page$/) do
  expect(page).to have_selector('body > *', count: 1)
  expect(page).to have_selector('body > div.map_container', count: 1)
end

Given (/^doit opportunities are imported with nil coordinates$/) do
  ImportDoItVolunteerOpportunities.with 3.0
end

Given (/^reachskills opportunities are imported with nil coordinates$/) do
  ImportReachSkillsVolunteerOpportunities.with
end

Then("there should be zero nil coordinates") do
  expect(VolunteerOp.where(latitude: nil).count).to eq 0
  expect(VolunteerOp.where(longitude: nil).count).to eq 0
end

Then (/^(\d+) default Harrow coordinates should be assigned$/) do |num_coords|
  expect(VolunteerOp.where(latitude: 51.58056).count).to eq num_coords.to_i
  expect(VolunteerOp.where(longitude: -0.34199).count).to eq num_coords.to_i
end

def check_for_org_info_box tbl, selector
  expect(page).to have_css(selector, :count => tbl.length)
  Organisation.where(name: tbl)
        .pluck(:name, :description, :id, :slug)
        .map {|name, desc, id, frdly_id| [name, smart_truncate(desc, 44), id, frdly_id]}
        .each do |name, desc, id, friendly_id|
      click_map_icon(id, selector)
      expect(page).to have_css('.arrow_box')
      expect(find('.arrow_box')).to have_content(desc)
      expect(find('.arrow_box')).to have_content(name)
      link = find('.arrow_box').find('a')[:href]
      expect(link).to end_with(organisation_path(friendly_id))
  end
end

def check_for_volop_info_box(tbl, selector, check_tbl_length = true)
  expect(page).to have_css(selector, count: tbl.length) if check_tbl_length
  VolunteerOp.where(title: tbl)
        .map {|volop| [volop.id, volop.organisation.name, volop.title,
          smart_truncate(volop.description, 44), volop.organisation.slug]}
        .each do |id, name, title, desc, org_friendly_id|
      all(selector).map do |list_item|
        list_item.trigger(:mouseover) if list_item.first('a').text == title
      end
      expect(page).to have_css('.arrow_box')
      expect(find('.arrow_box')).to have_content(desc)
      expect(find('.arrow_box')).to have_content(name)
      expect(find('.arrow_box').first('a', text: name)[:href]).to end_with(org_friendly_id)
      expect(find('.arrow_box').first('a', text: title)[:href]).to end_with(id.to_s)
  end
end

def check_info_box_link_opens_in_new_page(tbl, selector)
  VolunteerOp.where(title: tbl)
      .map {|volop| [volop.id, volop.organisation.name, volop.title,
                     smart_truncate(volop.description, 44), volop.organisation.slug]}
      .each do |id, name, title, desc, org_friendly_id|
    all(selector).map do |list_item|
      list_item.trigger(:mouseover) if list_item.first('a').text == title
    end
    expect { click_link(name) }.to change(&number_of_windows).by 1
  end
end

def check_for_no_org_info_box(tbl, selector, check_tbl_length = true)
  expect(page).to have_css(selector, count: tbl.length) if check_tbl_length
  Organisation.where(name: tbl)
        .pluck(:name, :description, :id, :slug)
        .map {|name, desc, id, frdly_id| [name, smart_truncate(desc, 42), id, frdly_id]}
        .each do |name, desc, id, friendly_id|
      find(selector).trigger(:mouseleave)
      expect(page).not_to have_css('.arrow_box')
      expect(find('.arrow_box')).not_to have_content(desc)
      expect(find('.arrow_box')).not_to have_content(name)
  end
end

def click_map_icon id, selector
  expect(page).to have_css("#{selector}[data-id='#{id}']")
  icon = find("#{selector}[data-id='#{id}']")
  click_twice icon
end

def click_twice elt
  elt.trigger('click')
  elt.trigger('click')
end

def find_map_icon klass, org_id
  expect(page).to have_css ".#{klass}[data-id='#{org_id}']"
  find(".#{klass}[data-id='#{org_id}']")
end

Then /^the (proposed organisation|organisation) "(.*?)" should have a (large|small) icon$/ do |type, name, icon_size|
  klass = case type
  when 'proposed organisation'
    ProposedOrganisation
  when 'organisation'
    Organisation
  else
    raise "Unknown class #{type}"
  end
  org_id = klass.find_by(name: name).id
  marker_class = (icon_size == "small") ? "measle" : "marker"
  if marker_class == "measle"
    expect(find_map_icon(marker_class, org_id)["src"]).to match /\/assets\/measle-(\w*)\.png$/ix
  else
    expect(find_map_icon(marker_class, org_id)["src"]).to match /\/assets\/marker-(\w*)\.png$/ix
  end
end

Then /^I should( not)? see the following (measle|vol_op|event|pin) markers in the map:$/ do |negative, klass, table|
  klass_hash = {'measle' => '.measle', 'vol_op' => '.vol_op', 'event' => '.vol_op', 'pin' => '.marker'}
  expect(page).to have_css(klass_hash[klass], :count => table.raw.flatten.length)
  marker_data = page.find('#marker_data')['data-markers']
  table.raw.flatten do |title|
    if negative
      expect(marker_data).not_to include(title)
    else
      expect(marker_data).to include(title)
     end
  end
end

Given(/^the map should show the opportunity titled (.*)$/) do |opportunity_title|
  opportunity_description = VolunteerOp.find_by(title: opportunity_title).description
  marker_data = page.find('#marker_data')['data-markers']
  expect(marker_data).to include(opportunity_title)
end

def markers
  find('#marker_data')['data-markers']
end

def marker_json_for_org_names(*org_names)
    marker_json = JSON.parse markers
    [*org_names].map do |name|
      marker_json.find{|m| m['infowindow'].include? name }
    end
end

Then /^the coordinates for "(.*?)" should( not)? be "(.*?), (.*?)"/ do | org1_name, negation, lat, lng |
  org1 = marker_json_for_org_names(org1_name).first
  if negation
    expect(org1['lat']).not_to eq lat.to_f
    expect(org1['lng']).not_to eq lng.to_f
  else
    expect(org1['lat']).to eq lat.to_f
    expect(org1['lng']).to eq lng.to_f
  end
end


Then /^the coordinates for "(.*?)" and "(.*?)" should( not)? be the same/ do | org1_name, org2_name, negation |
  org1, org2 = marker_json_for_org_names(org1_name, org2_name)
  if negation
    expect(org1['lat']).not_to eq org2['lat']
    expect(org1['lng']).not_to eq org2['lng']
  else
    expect(org1['lat']).to eq org2['lat']
    expect(org1['lng']).to eq org2['lng']
  end
end

Then /^I should see search results for "(.*?)" in the table$/ do |search_terms|
  orgs = Organisation.search_by_keyword(search_terms)
  orgs.each do |org|
    matches = page.html.match %Q<{\\"description\\":\\".*>#{org.name}</a>.*\\",\\"lat\\":((?:-|)\\d+\.\\d+),\\"lng\\":((?:-|)\\d+\.\\d+)}>
    expect(matches).not_to be_nil
  end
end

#TODO if this ever needs refactoring, factor it in with what's in
# config/initializers/webmock.rb
def stub_request_with_address(address, body = nil)
  #filename = "#{address.gsub(/\s/, '_')}.json"
  #filename = File.read "test/fixtures/#{filename}"
  # Webmock shows URLs with '%20' standing for space, but uri_encode susbtitutes with '+'
  # So let's fix
  #addr_in_uri = address.uri_encode.gsub(/\+/, "%20")
  # Stub request, which URL matches Regex
  #stub_request(:get, /http:\/\/maps.googleapis.com\/maps\/api\/geocode\/json\?address=#{addr_in_uri}/).
  #    to_return(status => 200, :body => body || filename, :headers => {})
end

Given /Google is indisposed for "(.*)"/ do  |address|
  body = %Q({
"results" : [],
"status" : "OVER_QUERY_LIMIT"
})
  stub_request_with_address(address, body)
end

And(/^"(.*?)" should not have nil coordinates$/) do |name|
  org = Organisation.find_by_name(name)
  org.latitude.should_not be_nil
  org.longitude.should_not be_nil
end

GMAPS_URL_KEY_NIL = 'https://maps.google.com/maps/api/js?' +
                    'v=3&libraries=geometry&key='.freeze

Then(/^the google map key should( not)? be appended to the gmap js script$/) do |negation|
  script_css = "script[src='#{GMAPS_URL_KEY_NIL}#{ENV['GMAP_API_KEY']}']"
  if negation
    expect(page.body).not_to have_css "script[src='#{GMAPS_URL_KEY_NIL}']", visible: false
    expect(page.body).not_to have_css script_css, visible: false
  else
    expect(page.body).to have_css script_css, visible: false
  end
end

Given(/^the Google Maps API key is( not)? set$/) do |negation|
  ENV['GMAP_API_KEY'] = negation ? nil : '12345'
end
