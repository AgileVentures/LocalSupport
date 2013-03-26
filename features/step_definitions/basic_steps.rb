Then /^show me the page$/ do
  save_and_open_page
end

Then /^I should see "(.*?)", "(.*?)" and "(.*?)" in the map$/ do |name1, name2, name3|
  org1 = Organization.find_by_name(name1)
  org2 = Organization.find_by_name(name2)
  org3 = Organization.find_by_name(name3)
  page.should have_xpath "//script[contains(.,'Gmaps.map.markers = [{\"lat\":#{org3.latitude},\"lng\":#{org3.longitude}},{\"lat\":#{org2.latitude},\"lng\":#{org2.longitude}},{\"lat\":#{org1.latitude},\"lng\":#{org1.longitude}}];')]"

#Gmaps.map.markers = [{"lat":51.5814093,"lng":-0.343908},{"lat":51.5813411,"lng":-0.3468075},{"lat":51.58125769999999,"lng":-0.3473078}];
#Gmaps.map.markers = [{"lat":51.5814093,"lng":-0.343908},{"lat":51.58125769999999,"lng":-0.3473078},{"lat":51.5813411,"lng":-0.3468075}];)]

#Gmaps.map.markers = [{"lat":51.5814093,"lng":-0.343908},{"lat":51.5813411,"lng":-0.3468075},{"lat":51.58125769999999,"lng":-0.3473078}];
#Gmaps.map.markers = [{"lat":51.5814093,"lng":-0.343908},{"lat":51.5813411,"lng":-0.3468075},{"lat":51.58125769999999,"lng":-0.3473078}];

#Gmaps.map.markers = [{"lat":51.5814093,"lng":-0.343908},{"lat":51.5813411,"lng":-0.3468075},{"lat":51.58125769999999,"lng":-0.3473078}];





end

Given /the following organizations exist/ do |organizations_table|
  organizations_table.hashes.each do |org|
    Organization.create! org
  end
end

Given /^I am on the home page$/ do
  visit "/"
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

Then /^I should see contact details for "([^"]*?)", "([^"]*?)" and "(.*?)"$/ do |text1, text2, text3|
  page.should have_content text1
  page.should have_content text2
  page.should have_content text3
end

