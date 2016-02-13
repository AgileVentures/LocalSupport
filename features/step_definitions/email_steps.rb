
def expect_email_exists(message: nil, email: nil, link: nil, link_text: nil)
  #TODO: use mandatory keyword arguments, ie. message:, when upgrading to ruby 2.1
  if message == nil || email == nil
    raise "Must supply message and email address!"
  end
  mails = ActionMailer::Base.deliveries.select{|m| m.to.include? email}
  expect(mails).not_to be_empty
  bodys = mails.map{|m| m.body}.select{|body| body.include? message }
  expect(bodys).not_to be_empty
  if link && link_text
    href = Nokogiri::HTML(bodys.first.raw_source).search("//a[text()='#{link_text}']")[0].attribute("href").value
    expect(href).to eq link
  end
end


And(/^an email should be sent to "(.*?)" as notice of becoming org admin of "(.*?)"$/) do |email, org_name|
  message = "You have been made an organisation admin for the organisation called #{org_name} on the Harrow Community Network. After logging in,
you will be able to update your organisation's directory entry."
  expect_email_exists(message: message, email: email, link: organisation_url(Organisation.find_by(name: org_name)),
                      link_text: "Click here to view your organisation on the Harrow Community Network.")
end

And(/^an email should be sent to "(.*?)" as notification of the request for admin status of "(.*?)"$/) do |email, org_name|
  message = "There is a user waiting for superadmin approval to #{org_name}"
  expect_email_exists(message: message,email: email)
end

And(/^an email should be sent to "(.*?)" as notification of the proposed edit to "(.*?)"$/) do |email, org_name|
  message = "There is an edit awaiting for superadmin approval to #{org_name}."
  expect_email_exists(message: message, email: email)
end

Then(/^an email should be sent to "(.*?)" as notification of the acceptance of proposed organisation "(.*?)"$/) do |email, org_name|
  message = "Thank you for registering your organisation.\n\nWe have granted your request to have it included in our directory.\n\nDetails of your organisation are now live in our directory."
  expect_email_exists(message: message, email: email, link: organisation_url(Organisation.find_by(name: org_name)) , link_text: "You can edit your organisation details by logging in and editing it directly.")
end

Then(/^an invitational email should be sent to "(.*?)" as notification of the acceptance of proposed organisation "(.*?)"$/) do |email, org_name|
  message = "Thank you for registering your organisation.\n\nWe have granted your request to have it included in our directory.\n\nDetails of your organisation are now live in our directory."
  expect_email_exists(message: message, email: email)
end

Then(/^an email should be sent to "(.*?)" as notification of the signup by email "(.*?)"$/) do |email, user_email|
  message = "A new user with the email #{user_email} has signed up on Harrow Community Network."
  expect_email_exists(message: message,email: email)
end

Then(/^an email should be sent to "(.*?)" as notification of the proposed organisation$/) do |email|
  message = "A new organisation called #{proposed_org_fields[:name]} has been proposed for inclusion in the Harrow Community Network."
  expect_email_exists(message: message,email: email,
    link: proposed_organisation_url(ProposedOrganisation.find_by(name: proposed_org_fields[:name])),
    link_text: "Click here to view this proposed organisation"
  )
end

And /^I should receive a "(.*?)" email$/ do |subj|
  mails = ActionMailer::Base.deliveries
  expect(mails).not_to be_empty
  subjects = mails.map(&:subject)
  expect(subjects).to include subj
end

And /^I should not receive an email$/ do
  ActionMailer::Base.deliveries.size.should eq 0
end

And /^the email queue is clear$/ do
  ActionMailer::Base.deliveries.clear
end

Given(/^I run the fix invitations rake task$/) do
  require "rake"
  @rake = Rake::Application.new
  Rake.application = @rake
  Rake.application.rake_require "tasks/fix_invites"
  Rake::Task.define_task(:environment)
  @rake['db:fix_invites'].invoke
end


Given(/^I import emails from "(.*?)"$/) do |file|
  require "rake"
  @rake = Rake::Application.new
  Rake.application = @rake
  Rake.application.rake_require "tasks/emails"
  Rake::Task.define_task(:environment)
  @rake['db:import:emails'].invoke(file)
end
