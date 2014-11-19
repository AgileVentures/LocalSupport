Then /^I should see hyperlinks for "(.*?)", "(.*?)" and "(.*?)" in the map$/ do |org1, org2, org3|
  marker_json = JSON.parse markers
  descriptions = marker_json.map{|m| m['infowindow'] }.join
  Organisation.where(name: [org1, org2, org3]).each do |org|
    expect(descriptions).to have_xpath "//a[@href=\"#{organisation_path(org.id)}\"]", :text => "#{org.name}"
  end
end

# could we move maps stuff into separate step file and couldn't these things be DRYer ...
# e.g. one step to handle 2 or more orgs ...
Then /^I should see "([^"]*?)", "([^"]*?)" and "([^"]*?)" in the map$/ do |name1, name2, name3|
  names = [name1, name2, name3]
  names_coords = names.map{|org_name| {name: org_name, lat: Organisation.where(name: org_name).first.latitude, lng: Organisation.where(name: org_name).first.longitude}}
  names_coords.each do |name_coord|
    org_name = name_coord[:name]
    result = JSON.parse(markers).select{|marker| marker["infowindow"].include? org_name}
    expect(result.length).to eq 1
    expect(result.first["lat"]).to eq name_coord[:lat] 
    expect(result.first["lng"]).to eq name_coord[:lng] 
  end
end

Then /^I should see "([^"]*?)" and "([^"]*?)" in the map$/ do |name1, name2|
  names = [name1, name2]
  coords = Organisation.where(name: names).pluck(:latitude, :longitude).flatten.uniq

  expect_markers_to_have_words(names)
  expect_markers_to_have_words(coords)
end

Given(/^the map should show the opportunity (.*)$/) do |opportunity_description|
  expect_markers_to_have_words(opportunity_description)
end

def markers
  find('#marker_data')['data-markers']
end

def expect_markers_to_have_words(*words)
  [*words].flatten.each do |word|
    expect(markers).to include word.to_s
  end
end

def marker_json_for_org_names(*org_names)
  marker_json = JSON.parse markers
  [*org_names].map do |name|
    marker_json.find{|m| m['infowindow'].include? name }
  end
end

Then /^the coordinates for "(.*?)" and "(.*?)" should( not)? be the same/ do | org1_name, org2_name, negation|
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
