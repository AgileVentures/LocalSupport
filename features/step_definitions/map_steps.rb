Then /^I should see hyperlinks for "(.*?)", "(.*?)" and "(.*?)" in the map$/ do |org1, org2, org3|
  markers = JSON.parse(find('#marker_data')['data-markers'])
  descriptions = markers.map{|m| m['infowindow'] }.join
  Organisation.where(name: [org1, org2, org3]).pluck(:description).each do |description|
    expect(descriptions).to include description
  end
end

# could we move maps stuff into separate step file and couldn't these things be DRYer ...
# e.g. one step to handle 2 or more orgs ...
Then /^I should see "([^"]*?)", "([^"]*?)" and "([^"]*?)" in the map centered on local organisations$/ do |name1, name2, name3|
  markers = find('#marker_data')['data-markers']
  check_map(markers, name1, name2, name3)
end

Then /^I should see "([^"]*?)" and "([^"]*?)" in the map$/ do |name1, name2|
  check_map([name1,name2])
end

Given(/^the map should show the opportunity (.*)$/) do |op|
    page.should have_xpath "//script[contains(.,'#{op}')]", :visible => false
end

def check_map(markers, *names)
  names.each do |name|
    expect(markers).to include name
  end

  Organisation.where(name: names).pluck(:latitude, :longitude).flatten.uniq.each do |coord|
    expect(markers).to include coord.to_s
  end
end

def markers_for_org_names(markers, *org_names)
  [*org_names].map do |name|
    markers.find{|m| m['infowindow'].include? name }
  end
end

Then /^the coordinates for "(.*?)" and "(.*?)" should( not)? be the same/ do | org1_name, org2_name, negation|
  markers = JSON.parse(find('#marker_data')['data-markers'])
  org1, org2 = markers_for_org_names(markers, org1_name, org2_name)

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
