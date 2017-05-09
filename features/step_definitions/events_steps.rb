Given (/^I fill in the new event page validly$/) do
  fill_in 'event_title', with: 'Hackathon'
  fill_in 'event_description', with: 'Great place to brain storm'

  select '2018', from: 'event_start_date_1i'
  select 'April', from: 'event_start_date_2i'
  select '20', from: 'event_start_date_3i'
  select '08', from: 'event_start_date_4i'
  select '28', from: 'event_start_date_5i'

  select '2018', from: 'event_end_date_1i'
  select 'April', from: 'event_end_date_2i'
  select '10', from: 'event_end_date_3i'
  select '15', from: 'event_end_date_4i'
  select '30', from: 'event_end_date_5i'
end

Given /^I create "(.*?)" event$/ do |name|
  page.driver.submit :post, '/events', event: {name: name}
end

Then /^"(.*?)" event should not exist$/ do |title|
  expect(Event.find_by_title title).to be_nil
end
