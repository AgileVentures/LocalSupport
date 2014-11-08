Then /^I should see hyperlinks for "(.*?)", "(.*?)" and "(.*?)" in the map$/ do |org1, org2, org3|
  org1 = Organisation.find_by_name(org1)
  org2 = Organisation.find_by_name(org2)
  org3 = Organisation.find_by_name(org3)
  [org1,org2,org3].each do |org|
    match = page.html.match %Q<{\\"description\\":\\".*>#{org.name}</a>.*\\",\\"lat\\":((?:-|)\\d+\.\\d+),\\"lng\\":((?:-|)\\d+\.\\d+)}>
    expect(match).not_to be_nil
    # the following might work if we were actually running all the gmaps js
    #expect(page).to have_xpath("//div[@class='map_container']//a[@href='#{organisation_path(org)}']")
  end
end

Then /^the organisation "(.*?)" should have a (large|small) icon$/ do |name, icon_size|
  org = Organisation.find_by_name(name)
  org_description = smart_truncate(org.description, 32)
  if icon_size == "small"
    page.should have_xpath("//head//script[contains(string(),'#{org_description}\"\,\"picture\":\"/assets/redcircle.png\"')]", :visible => false)
  else
    page.should_not have_xpath("//head//script[contains(string(),'#{org_description}\"\,\"picture\":\"/assets/redcircle.png\"')]", :visible => false)
    page.should have_xpath("//head//script[contains(string(),'#{org_description}\"\,\"lat\":#{org.latitude},\"lng\":#{org.longitude}')]", :visible => false)
  end
end
# could we move maps stuff into separate step file and couldn't these things be DRYer ...
# e.g. one step to handle 2 or more orgs ...
Then /^I should see "([^"]*?)", "([^"]*?)" and "([^"]*?)" in the map centered on local organisations$/ do |name1, name2, name3|
  check_map([name1,name2,name3])

  ['Gmaps.map.map_options.auto_adjust = false',
   'Gmaps.map.map_options.auto_zoom = true',
   'Gmaps.map.map_options.center_latitude = 51.5978',
   'Gmaps.map.map_options.center_longitude = -0.337',
   'Gmaps.map.map_options.zoom = 12',
   'Gmaps.map.map_options.auto_adjust = false'].each {|option| check_script_tag(option)}

end

Then /^I should see "([^"]*?)" and "([^"]*?)" in the map$/ do |name1, name2|
  check_map([name1,name2])
end

Given(/^the map should show the opportunity (.*)$/) do |op|
    page.should have_xpath "//script[contains(.,'#{op}')]", :visible => false
end

def check_script_tag(filter)
  page.should have_xpath "//script[contains(.,\'#{filter}\')]", :visible => false
end

def check_map(names)
  names.each do |name|
    check_script_tag(name)
    Organisation.all.to_gmaps4rails.should match(name)
  end
end

Then /^I should see search results for "(.*?)" in the table$/ do |search_terms|
  orgs = Organisation.search_by_keyword(search_terms)
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
  org = Organisation.find_by_name(name)
  org.latitude.should_not be_nil
  org.longitude.should_not be_nil
end

Then /^the coordinates for "(.*?)" and "(.*?)" should( not)? be the same/ do | org1_name, org2_name, negation|
  #Gmaps.map.markers = [{"description":"<a href=\"/organisations/1320\">test</a>","lat":50.3739788,"lng":-95.84172219999999}];

  matches = page.html.match %Q<{(?:\\"zindex\\":1,)?\\"description\\":\\"[^}]*#{org1_name}[^}]*\\",\\"lat\\":((?:-|)\\d+\.\\d+),\\"lng\\":((?:-|)\\d+\.\\d+)}>
  org1_lat = matches[1]
  org1_lng = matches[2]
  matches = page.html.match %Q<{(?:\\"zindex\\":1,)?\\"description\\":\\"[^}]*#{org2_name}[^}]*\\",\\"lat\\":((?:-|)\\d+\.\\d+),\\"lng\\":((?:-|)\\d+\.\\d+)}>
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
