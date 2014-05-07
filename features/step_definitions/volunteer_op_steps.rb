And(/^I submit an opportunity with title "(.*?)" and description "(.*?)"$/) do |title, description|
  fill_in 'Title', :with => title
  fill_in 'Description', :with => description
  click_on 'Create a Volunteer Opportunity'
end

Given(/^that the (.+) flag is (enabled|disabled)$/) do |feature, state|
  if state == 'enabled'
    Feature.activate(feature)
  else
    Feature.deactivate(feature)
  end
end

Given /the following feature flags exist/ do |feature_flags_table|
  feature_flags_table.hashes.each do |feature_flag|
    Feature.create! feature_flag
  end
end
