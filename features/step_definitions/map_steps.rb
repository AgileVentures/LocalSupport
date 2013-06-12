
# could we move maps stuff into separate step file and couldn't these things be DRYer ...
# e.g. one step to handle 2 or more orgs ...
Then /^I should see "([^"]*?)", "([^"]*?)" and "([^"]*?)" in the map centered on local organizations$/ do |name1, name2, name3|
  check_map([name1,name2,name3])
  page.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
  page.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_zoom = true')]"
  page.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_latitude = 51.5978')]"
  page.should have_xpath "//script[contains(.,'Gmaps.map.map_options.center_longitude = -0.337')]"
  page.should have_xpath "//script[contains(.,'Gmaps.map.map_options.zoom = 12')]"
  page.should have_xpath "//script[contains(.,'Gmaps.map.map_options.auto_adjust = false')]"
end

Then /^I should see "([^"]*?)" and "([^"]*?)" in the map$/ do |name1, name2|
  check_map([name1,name2])
end


def check_map(names)
  # this is specific to checking for all items when we want a generic one
  #page.should have_xpath "//script[contains(.,'Gmaps.map.markers = #{Organization.all.to_gmaps4rails}')]"

  names.each do |name|
    page.should have_xpath "//script[contains(.,'#{name}')]"
    #org = Organization.find_by_name(name)
    Organization.all.to_gmaps4rails.should match(name)
  end
end


Then /^I should see search results for "(.*?)" in the map$/ do |search_terms|
  page.should have_xpath "//script[contains(.,'Gmaps.map.markers = #{Organization.search_by_keyword(search_terms).to_gmaps4rails}')]"
end

def stub_request_with_address(address, body = nil)
  filename = "#{address.gsub(/\s/, '_')}.json"
  filename = File.read "test/fixtures/#{filename}"
  # Webmock shows URLs with '%20' standing for space, but uri_encode susbtitutes with '+'
  # So let's fix
  addr_in_uri = address.uri_encode.gsub(/\+/, "%20")
  # Stub request, which URL matches Regex
  stub_request(:get, /http:\/\/maps.googleapis.com\/maps\/api\/geocode\/json\?address=#{addr_in_uri}/).
      to_return(status => 200, :body => body || filename, :headers => {})
end

Given /the following organizations exist/ do |organizations_table|
  organizations_table.hashes.each do |org|
    stub_request_with_address(org['address'])
    Organization.create! org
  end
end

When /^I edit the charity address to be "(.*?)"$/ do |address|
   stub_request_with_address(address)
   fill_in('organization_address',:with => address)
end

Given /^I edit the donation url to be "(.*?)"$/ do |url|
  fill_in('organization_donation_info', :with => url)
end

Then /^the coordinates for "(.*?)" and "(.*?)" should( not)? be the same/ do | org1_name, org2_name, negation|
  matches = page.html.match %Q<{\\"description\\":\\"#{org1_name}\\",\\"lat\\":((?:-|)\\d+\.\\d+),\\"lng\\":((?:-|)\\d+\.\\d+)}>
  org1_lat = matches[1]
  org1_lng = matches[2]
  if negation
    page.html.should_not have_content %Q<{"description":"#{org2_name}","lat":#{org1_lat},"lng":#{org1_lng}}>
  else 
    page.html.should have_content %Q<{"description":"#{org2_name}","lat":#{org1_lat},"lng":#{org1_lng}}>
  end
end

