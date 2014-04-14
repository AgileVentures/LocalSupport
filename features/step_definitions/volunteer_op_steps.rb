And(/^I submit an opportunity with title "(.*?)" and description "(.*?)"$/) do |title, description|
  fill_in 'Title', :with => title
  fill_in 'Description', :with => description
  click_on 'Create Volunteer Opportunity'
end