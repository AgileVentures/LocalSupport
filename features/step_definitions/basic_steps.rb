require 'webmock/cucumber'
require 'uri-handler'

Then /^show me the page$/ do
  save_and_open_page
end

Given /^PENDING/ do
  pending
end

Given /^I press "(.*?)"$/ do |button|
  click_button(button)
end

When /^I search for "(.*?)"$/ do |text|
  fill_in 'q', with: text
  click_button 'Search'
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

Then /^I should not see "(.*?)"$/ do |text|
  page.should_not have_content text
end

Then /^I should see "(.*?)"$/ do |text|
  page.should have_content text
end

# this could be DRYed out (next three methods)
Then /^I should see contact details for "([^"]*?)"$/ do |text|
  check_contact_details text
end

Then /^I should see contact details for "([^"]*?)" and "(.*?)"$/ do |text1, text2|
  check_contact_details text1
  check_contact_details text2
end

Then /^I should see contact details for "([^"]*?)", "([^"]*?)" and "(.*?)"$/ do |text1, text2, text3|
  check_contact_details text1
  check_contact_details text2
  check_contact_details text3
end

def check_contact_details(name)
  org = Organization.find_by_name(name)
  page.should have_link name, :href => organization_path(org.id)
end




