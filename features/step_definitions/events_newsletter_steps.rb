When(/^"([^"]*)" opens the email$/) do | user|
  user = User.where(superadmin: false)
end

Then(/^I should see email delivered from "([^"]*)"$/) do |sender|
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
