
# could we move maps stuff into separate step file and couldn't these things be DRYer ...
# e.g. one step to handle 2 or more orgs ...
Then /^I should see "([^"]*?)", "([^"]*?)" and "([^"]*?)" in the map$/ do |name1, name2, name3|
  check_map([name1,name2,name3])
end

Then /^I should see "([^"]*?)" and "([^"]*?)" in the map$/ do |name1, name2|
  check_map([name1,name2])
end

def check_map(names)
  # this is specific to cehcking for all items when we want a generic one
  #page.should have_xpath "//script[contains(.,'Gmaps.map.markers = #{Organization.all.to_gmaps4rails}')]"

  names.each do |name|
    #org = Organization.find_by_name(name)
    Organization.all.to_gmaps4rails.should match(name)
  end
end


Then /^I should see search results for "(.*?)" in the map$/ do |search_terms|
  page.should have_xpath "//script[contains(.,'Gmaps.map.markers = #{Organization.search_by_keyword(search_terms).to_gmaps4rails}')]"
end

def stub_request_with_address(address)
  filename = "#{address.gsub(/\s/, '_')}.json"
  filename = File.read "test/fixtures/#{filename}"
  # Webmock shows URLs with '%20' standing for space, but uri_encode susbtitutes with '+'
  # So let's fix
  addr_in_uri = address.uri_encode.gsub(/\+/, "%20")
  # Stub request, which URL matches Regex
  stub_request(:get, /http:\/\/maps.googleapis.com\/maps\/api\/geocode\/json\?address=#{addr_in_uri}/).
  to_return(status => 200, :body => filename, :headers => {})
end

Given /the following organizations exist/ do |organizations_table|
  organizations_table.hashes.each do |org|
    stub_request_with_address(org['address'])
    Organization.create! org
  end
end

Given /^the following users are registered:$/ do |charity_workers_table|
  charity_workers_table.hashes.each do |charity_worker|
    CharityWorker.create! charity_worker
  end
end

When /^I edit the charity address to be "(.*?)"$/ do |address|
   stub_request_with_address(address)
   fill_in('organization_address',:with => address)
end

Then /^the coordinates for "(.*?)" and "(.*?)" should be the same/ do | org1_name, org2_name|
  matches = page.html.match %Q<{\\"description\\":\\"#{org1_name}\\",\\"lat\\":((?:-|)\\d+\.\\d+),\\"lng\\":((?:-|)\\d+\.\\d+)}>
  org1_lat = matches[1]
  org1_lng = matches[2]
  page.html.should have_content  %Q<{"description":"#{org2_name}","lat":#{org1_lat},"lng":#{org1_lng}}>
end

