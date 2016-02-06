And(/^I submit a volunteer op "(.*?)", "(.*?)" on the "(.*?)" page$/) do |title, desc, org_name|
  org = Organisation.find_by_name(org_name)
  visit organisation_path org
  click_link "Create a Volunteer Opportunity"
  expect(current_path).to eq new_organisation_volunteer_op_path org
  fill_in 'Title', :with => title
  fill_in 'Description', :with => desc
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

Given /^I should see (\d+) markers in the map$/ do |num|
  expect(page).to have_css('.vol_op', count: num)
end

When /^I click the first "(.*)"$/ do |link|
  within("#1") do
    click_link(link)
  end
end

Then(/^I should be on do\-it "(.*?)" page$/) do |arg1|
  current_path.should eq arg1
end

Given(/^the map should show the do\-it opportunity titled (.*)$/) do |opportunity_title|
  icon = find_map_icon('vol_op', '10')
  click_twice icon
  expect(page).to have_css('.arrow_box')
  expect(find('.arrow_box').text).to include(opportunity_title)
end