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
  email = ActionMailer::Base.deliveries
  expect(email).to have_sender(sender)
end

Then(/^I should see "([^"]*)" in the email subject$/) do |subject|
  expect(email).to have_subject(subject)
  # current_email.subject.should =~ Regexp.new(text)
end

Then(/^I should see "([^"]*)" in the email body$/) do |text|
  expect(email).to have_content(text)
   # current_email.body.should =~ Regexp.new(text)
end
