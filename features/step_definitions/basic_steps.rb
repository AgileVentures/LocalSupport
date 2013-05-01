require 'webmock/cucumber'
require 'uri-handler'

Given /^I am on the charity page for "(.*?)"$/ do |name1|
  org1 = Organization.find_by_name(name1)
  visit organization_path org1.id
end

Given /^I am on the edit charity page for "(.*?)"$/ do |name1|
  org1 = Organization.find_by_name(name1)
  visit edit_organization_path org1.id
end

Then /^I should see the donation_info URL for "(.*?)"$/ do |name1|
  org1 = Organization.find_by_name(name1)
  page.should have_link "Donate to #{org1.name} now!", :href => org1.donation_info
end

Then /^I should not see the donation_info URL for "(.*?)"$/ do |name1|
  org1 = Organization.find_by_name(name1)
  page.should_not have_link "Donate to #{org1.name} now!"
  page.should have_content "We don't yet have any donation link for them."
end

Then /^show me the page$/ do
  save_and_open_page
end

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

Then /^I should not see any address or telephone information for "([^"]*?)" and "([^"]*?)"$/ do |name1, name2|
  org1 = Organization.find_by_name(name1)
  org2 = Organization.find_by_name(name2)
  page.should_not have_content org1.telephone
  page.should_not have_content org1.address
  page.should_not have_content org2.telephone
  page.should_not have_content org2.address
end

Then /^I should not see any address or telephone information for "([^"]*?)"$/ do |name1|
  org1 = Organization.find_by_name(name1)
  page.should_not have_content org1.telephone
  page.should_not have_content org1.address
end

Then /^I should not see any edit or delete links$/ do
  page.should_not have_link "Edit"
  page.should_not have_link "Destroy"
end

Then /^I should not see any edit link for "([^"]*?)"$/ do |name1|
  page.should_not have_link "Edit"
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

Given /^I am on the home page$/ do
  visit "/"
end

Given /^I am on the sign in page$/ do
  visit new_charity_worker_session_path
end

Given /^I am on the new charity page$/ do
  visit new_organization_path
end

Given /^I am on the sign up page$/ do
  visit new_charity_worker_registration_path
end

Then /^I should be on the new charity page$/ do
 current_path.should == new_organization_path
end

Then /^I should not see "(.*?)"$/ do |text|
  page.should_not have_content text
end
Then /^I should see "(.*?)"$/ do |text|
  page.should have_content text
end


When /^I search for "(.*?)"$/ do |text|
  fill_in 'q', with: text
  click_button 'Search'
end

Then /^I should see contact details for "([^"]*?)"$/ do |text|
  page.should have_content text
end

Then /^I should see contact details for "([^"]*?)" and "(.*?)"$/ do |text1, text2|
  page.should have_content text1
  page.should have_content text2
end


Then /^I should see contact details for "([^"]*?)", "([^"]*?)" and "(.*?)"$/ do |text1, text2, text3|
  page.should have_content text1
  page.should have_content text2
  page.should have_content text3
end
Given /^I sign in as "(.*?)" with password "(.*?)"$/ do |email, password|
  fill_in "Email" , :with => email
  fill_in "Password" , :with => password
  click_button "Sign in"
end

Given /^the following users are registered:$/ do |charity_workers_table|
  charity_workers_table.hashes.each do |charity_worker|
    CharityWorker.create! charity_worker
  end
end

Then /^I should be on the sign in page$/ do
  current_path.should == new_charity_worker_session_path
end

When /^I edit the charity address to be "(.*?)"$/ do |address|
   stub_request_with_address(address)
   fill_in('organization_address',:with => address)
end

Given /^I edit the charity address to be "(.*?)" when Google is indisposed$/ do |address|
   body = %Q({
   "results" : [],
   "status" : "ZERO_RESULTS"
   })
   stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=50%20pinner%20road,%20HA1%204HZ&language=en&sensor=false").
   to_return(:status => 200, :body => body, :headers => {})
   fill_in('organization_address', :with => address)
end

Given /^I press "(.*?)"$/ do |button|
  click_button(button)
end

Then /^the coordinates for "(.*?)" and "(.*?)" should be the same/ do | org1_name, org2_name|
  matches = page.html.match %Q<{\\"description\\":\\"#{org1_name}\\",\\"lat\\":((?:-|)\\d+\.\\d+),\\"lng\\":((?:-|)\\d+\.\\d+)}>
  org1_lat = matches[1]
  org1_lng = matches[2]
  page.html.should have_content  %Q<{"description":"#{org2_name}","lat":#{org1_lat},"lng":#{org1_lng}}>
end
Given /^PENDING/ do
  pending
end

Given /^that I am logged in as any user$/ do
  steps %Q{
     Given the following users are registered:
   | email             | password |
   | jcodefx@gmail.com | pppppppp |
  } 
  steps %Q{
    Given I am on the sign in page
    And I sign in as "jcodefx@gmail.com" with password "pppppppp"
  }
end

Then /^I should not be signed in as any user$/ do
  steps %Q{
    Given I am on the new charity page
    Then I should not see "Signed in as"
  }
end

When /^I sign out$/ do
  click_link 'Sign Out' 
end

Then /^I should be on the home page$/ do
  current_path.should == root_path()
end
