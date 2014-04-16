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

Given /Google is indisposed for "(.*)"/ do  |address|
  body = %Q({
"results" : [],
"status" : "OVER_QUERY_LIMIT"
})
  stub_request_with_address(address, body)
end

Given /the following categories exist/ do |categories_table|
  categories_table.hashes.each do |cat|
    Category.create! cat
  end
end

Given /^the following categories_organizations exist:$/ do |join_table|
  join_table.hashes.each do |row|
     cat = Category.find_by_name row[:category]
     org = Organization.find_by_name row[:organization]
     org.categories << cat
  end
end

Given /^the following pages exist:$/ do |pages_table|
  pages_table.hashes.each do |page|
    Page.create! page
  end
end

When(/^a static page named "(.*?)" with permalink "(.*?)" and markdown content:$/) do |name, permalink, content|
  Page.create!({:name => name, :permalink => permalink, :content => content})
end

Given /^I edit the donation url to be "(.*?)"$/ do |url|
  fill_in('organization_donation_info', :with => url)
end

And(/^"(.*?)" should not have nil coordinates$/) do |name|
  org = Organization.find_by_name(name)
  org.latitude.should_not be_nil
  org.longitude.should_not be_nil
end
