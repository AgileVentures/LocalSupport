And(/^I submit an opportunity with title "(.*?)" and description "(.*?)"$/) do |title, description|
  fill_in 'Title', :with => title
  fill_in 'Description', :with => description
  click_on 'Create a Volunteer Opportunity'
end

Given(/^that the (.+) flag is (enabled|disabled)$/) do |flag, state|
  if state == 'enabled'
    Feature.activate(:volunteer_ops)
  else
    Feature.deactivate(:volunteer_ops)
  end
end
