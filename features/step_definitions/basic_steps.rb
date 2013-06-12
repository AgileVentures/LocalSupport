require 'webmock/cucumber'
require 'uri-handler'

Then /^I should not see an edit button for "(.*?)" charity$/ do |name|
  org = Organization.find_by_name name
  expect(page).not_to have_link :href => edit_organization_path(org.id)
end

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

Given /^I fill in the new charity page validly$/ do
  stub_request_with_address("64 pinner road")
  fill_in 'organization_address', :with => '64 pinner road'
  fill_in 'organization_name', :with => 'Friendly charity'
end

Given /^I update "(.*?)" charity address to be "(.*?)"$/ do |name, address|
  steps %Q{
    Given I am on the edit charity page for "#{name}"
    And I edit the charity address to be "#{address}"
    And I press "Update Organization"
  }
end

Given /^I furtively update "(.*?)" charity address to be "(.*?)"$/ do |name, address|
  steps %Q{
    Given I am furtively on the edit charity page for "#{name}"
    And I edit the charity address to be "#{address}"
    And I press "Update Organization"
  }
end


And /^"(.*?)" charity address is "(.*?)"$/ do |name, address|
  org = Organization.find_by_name(name)
  expect(org.address).to eq(address)
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |name1,name2|
  str = page.body
  assert str.index(name1) < str.index(name2)

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

Then /^the donation_info URL for "(.*?)" should refer to "(.*?)"$/ do |name, href|
  expect(page).to have_link "Donate to #{name} now!", :href => href
end

Then /^I should not see any address or telephone information for "([^"]*?)" and "([^"]*?)"$/ do |name1, name2|
  org1 = Organization.find_by_name(name1)
  org2 = Organization.find_by_name(name2)
  page.should_not have_content org1.telephone
  page.should_not have_content org1.address
  page.should_not have_content org2.telephone
  page.should_not have_content org2.address
end

Given /^I update the "(.*?)"$/ do |name|
  org1 = Organization.find_by_name(name)
  org1.address = "84 pinner road"
  org1.save!
end


When /^(?:|I )follow "([^"]*)"$/ do |link|
    click_link(link)
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

Then /^I should see "((?:(?!before|").)+)"$/ do |text|
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

Given /^I edit the charity address to be "(.*?)" when Google is indisposed$/ do |address|
  body = %Q({
"results" : [],
"status" : "OVER_QUERY_LIMIT"
})
  stub_request_with_address(address, body)
  fill_in('organization_address', :with => address)
end

Then /^I should not see the unable to save organization error$/ do
  page.should_not have_content "1 error prohibited this organization from being saved:"
end

Then /^the address for "(.*?)" should be "(.*?)"$/ do |name, address|
  Organization.find_by_name(name).address.should == address
end

def check_contact_details(name)
  org = Organization.find_by_name(name)
  page.should have_link name, :href => organization_path(org.id)
  page.should have_content org.description.truncate(128,:omission=>' ...')
end

Then /^I should be on the sign up page$/ do
  current_path.should == new_user_registration_path
end

Then /^I should be on the charity workers page$/ do
  current_path.should == users_path
end

When /^I fill in "(.*?)" with "(.*?)"$/ do |field, value|
  fill_in(field, :with => value)
end
