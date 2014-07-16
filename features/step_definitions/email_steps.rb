And(/^an email should be sent to "(.*?)" confirming request$/) do |email|
  last_mail = ActionMailer::Base.deliveries.last
  expect(last_mail).not_to be_nil
  expect(last_mail.to).to eq email
  ActionMailer::Base.deliveries.size.should eq 1
end

And /^I should receive a "(.*?)" email$/ do |arg1|
  @email = ActionMailer::Base.deliveries.last
  @email.subject.should include(arg1)
  ActionMailer::Base.deliveries.size.should eq 1
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


