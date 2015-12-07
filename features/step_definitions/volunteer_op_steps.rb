And(/^I submit a volunteer op "(.*?)", "(.*?)" on the "(.*?)" page$/) do |title, desc, org_name|
  org = Organisation.find_by_name(org_name)
  visit organisation_path org
  click_link "Create a Volunteer Opportunity"
  expect(current_path).to eq new_organisation_volunteer_op_path org
  fill_in 'Title', :with => title
  fill_in 'Description', :with => desc
  check 'Use organisation address as location for volunteer opportunity'
  click_on 'Create a Volunteer Opportunity'
end

Then(/^I submit a volunteer op located at "(.*?)", "(.*?)" and titled "(.*?)", "(.*?)" on the "(.*?)" page$/) do |address, postcode, title, desc, org_name, |
  org = Organisation.find_by_name(org_name)
  visit organisation_path org
  click_link "Create a Volunteer Opportunity"
  expect(current_path).to eq new_organisation_volunteer_op_path org
  save_and_open_page
  fill_in 'Title', :with => title
  fill_in 'Description', :with => desc
  fill_in 'Address', :with => address
  fill_in 'Postcode', :with => postcode
  click_on 'Create a Volunteer Opportunity'
end

Given(/^that the (.+) flag is (enabled|disabled)$/) do |feature, state|
  if f = Feature.find_by_name(feature) then
    f.update_attributes(active: (state == 'enabled'))
  else
    Feature.create!(name: feature, active: (state == 'enabled'))
  end
end

Given /^I update "(.*?)" volunteer op description to be "(.*?)"$/ do |title, description|
  vop = VolunteerOp.find_by_title title
  visit volunteer_op_path vop
  click_on 'Edit'
  fill_in('Description', :with => description)
  click_on 'Update a Volunteer Opportunity'
end
