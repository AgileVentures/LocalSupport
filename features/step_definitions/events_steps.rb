Given (/^I fill in the new event page validly$/) do
  fill_in 'event_title', with: 'Hackathon'
  fill_in 'event_description', with: 'Great place to brain storm'
  fill_in 'event_start_date', with: '20/04/2038 09:00'
  fill_in 'event_end_date', with: '28/04/2038 09:20'
  select('Us', from: 'event_organisation_id')
end

Given /^I create "(.*?)" event$/ do |name|
  page.driver.submit :post, '/events', event: {name: name}
end

Then /^"(.*?)" event should not exist$/ do |title|
  expect(Event.find_by_title title).to be_nil
end

Given(/^the following events? exists?:$/) do |table|
  table.hashes.each do |hash|
    hash['organisation'] = Organisation.find_by_name(hash['organisation'])
    hash['start_date'] = Time.zone.now + 1.day if hash['start_date'] == 'one day from now'
    hash['start_date'] = Time.zone.now - 1.day if hash['start_date'] == 'yesterday'
    hash['start_date'] = Time.zone.now if hash['start_date'] == 'today'
    hash['end_date'] = (Time.zone.now + 3.hours) + 1.day  if hash['end_date'] == 'one day from now'
    hash['end_date'] = (Time.zone.now + 3.hours) - 1.day if hash['end_date'] == 'yesterday'
    hash['end_date'] = Time.zone.now + 3.hours if hash['end_date'] == 'today'
    Event.create!(hash)
  end
end

Given(/^I remove the organisation from the event "(.*?)"$/) do |event|
  event = Event.find_by_title(event)
  event.update(organisation_id: nil)
end

Given(/^I visit "([^"]*)" event$/) do |title|
  event = Event.find_by_title(title)
  visit "/events/#{event.id}"
end

Then("I should see {string} event description marker in {string} event location in the map") do |description, event|
  marker_data = page.find('#marker_data')['data-markers']
  expect(marker_data).to include(description)
  event = Event.find_by(title: event)
  latitude = "0.0"
  longitude = "0.0"
  if event.address == "64 pinner road"
    latitude = "35.4513251"
    longitude = "-82.5505013"
  end
  expect(marker_data).to include(latitude)
  expect(marker_data).to include(longitude)
end

When("I click on the {string} text field") do |string|
  find(string).click
end
