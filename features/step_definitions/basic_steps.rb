Then /^I should see "(.*?)" and "(.*?)" in the map$/ do |name1, name2|
  page.should have_xpath "//script[contains(.,'Gmaps.map.markers = [{\"lat\":')]"
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

Then /^I should see contact details for "([^"]*?)" and "([^"]*?)"$/ do |text1, text2|
  page.should have_content text1
  page.should have_content text2
end

