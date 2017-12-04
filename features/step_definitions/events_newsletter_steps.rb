When(/^the events newsletter task runs$/) do
  users = User.where(superadmin: false)
  user = users.first
  events = Event.all
 EventNewsLetterMailer.monthly_newsletter(user, events).deliver_now
end

When(/^"([^"]*)" opens the email$/) do | user|
  user = User.where(superadmin: false)
end

Then(/^I should see email delivered from "([^"]*)"$/) do |sender|
  users = User.where(superadmin: false)
  user = users.first
  events = Event.all
  users = User.where(superadmin: false)
  mail = EventNewsLetterMailer.monthly_newsletter(user, events)
  expect(mail.from).to eq(['support@harrowcn.org.uk'])
end

Then(/^I should see "([^"]*)" in the email subject$/) do |subject|
  users = User.where(superadmin: false)
  user = users.first
  events = Event.all
  users = User.where(superadmin: false)
  mail = EventNewsLetterMailer.monthly_newsletter(user, events)
  expect(mail.subject).to eq('Upcoming events updates')
end

Then(/^I should see "([^"]*)" in the email body$/) do |text|
  users = User.where(superadmin: false)
  user = users.first
  events = Event.all
  users = User.where(superadmin: false)
  mail = EventNewsLetterMailer.monthly_newsletter(user, events)
  expect(mail.body).to have_content("Open Source Weekend") 
end
