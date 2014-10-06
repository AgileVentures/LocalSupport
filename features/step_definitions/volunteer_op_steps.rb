And(/^I submit a volunteer op "(.*?)", "(.*?)" on the "(.*?)" page$/) do |title, desc, org|
  step "I visit the show page for the organisation named \"#{org}\""
  click_link "Create a Volunteer Opportunity"
  step "I should be on the new volunteer op page for \"#{org}\""
  step "I submit an opportunity with title \"#{title}\" and description \"#{desc}\""
end

And(/^I submit an opportunity with title "(.*?)" and description "(.*?)"$/) do |title, description|
  fill_in 'Title', :with => title
  fill_in 'Description', :with => description
  click_on 'Create a Volunteer Opportunity'
end

Given(/^that the (.+) flag is (enabled|disabled)$/) do |feature, state|
  if f = Feature.find_by_name(feature) then
    f.update_attributes(active: (state == 'enabled'))
  else
    Feature.create!(name: feature, active: (state == 'enabled'))
  end
end

Given /^I update "(.*?)" description to be "(.*?)"$/ do |title, description|
  steps %Q{
    Given I visit the show page for the volunteer_op titled "#{title}"
    And I follow "Edit"
    And I edit the description to be "#{description}"
    And I press "Update a Volunteer Opportunity"
  }
end

Given /^I edit the description to be "(.*?)"$/ do |text|
  fill_in('Description', :with => text)
end

Then /^the description for "(.*?)" should be "(.*?)"$/ do |title, description|
  expect(VolunteerOp.find_by_title(title).description).to eql(description)
end
