Then /^I should see hyperlinks for "(.*?)", "(.*?)" and "(.*?)" in the map$/ do |org1, org2, org3|
  org1 = Organization.find_by_name(org1)
  org2 = Organization.find_by_name(org2)
  org3 = Organization.find_by_name(org3)
  [org1,org2,org3].each do |org|
    match = page.html.match %Q<{\\"description\\":\\".*>#{org.name}</a>.*\\",\\"lat\\":((?:-|)\\d+\.\\d+),\\"lng\\":((?:-|)\\d+\.\\d+)}>
    expect(match).not_to be_nil
    # the following might work if we were actually running all the gmaps js
    #expect(page).to have_xpath("//div[@class='map_container']//a[@href='#{organization_path(org)}']")
  end
end

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
  orgs = Organization.search_by_keyword(search_terms)
  orgs.each do |org|
    matches = page.html.match %Q<{\\"description\\":\\".*>#{org.name}</a>.*\\",\\"lat\\":((?:-|)\\d+\.\\d+),\\"lng\\":((?:-|)\\d+\.\\d+)}>
    expect(matches).not_to be_nil
  end
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

Given /Google is indisposed for "(.*)"/ do  |address|
  body = %Q({
"results" : [],
"status" : "OVER_QUERY_LIMIT"
})
  stub_request_with_address(address, body)
end

And(/^"(.*?)" should not have nil coordinates$/) do |name|
  org = Organization.find_by_name(name)
  org.latitude.should_not be_nil
  org.longitude.should_not be_nil
end

Then /^the coordinates for "(.*?)" and "(.*?)" should( not)? be the same/ do | org1_name, org2_name, negation|
  #Gmaps.map.markers = [{"description":"<a href=\"/organizations/1320\">test</a>","lat":50.3739788,"lng":-95.84172219999999}];

  matches = page.html.match %Q<{\\"description\\":\\"[^}]*#{org1_name}[^}]*\\",\\"lat\\":((?:-|)\\d+\.\\d+),\\"lng\\":((?:-|)\\d+\.\\d+)}>
  org1_lat = matches[1]
  org1_lng = matches[2]
  matches = page.html.match %Q<{\\"description\\":\\"[^}]*#{org2_name}[^}]*\\",\\"lat\\":((?:-|)\\d+\.\\d+),\\"lng\\":((?:-|)\\d+\.\\d+)}>
  org2_lat = matches[1]
  org2_lng = matches[2]
  lat_same = org1_lat == org2_lat
  lng_same = org1_lng == org2_lng
  if negation
    expect(lat_same && lng_same).to be_false
  else
    expect(lat_same && lng_same).to be_true
  end
end
