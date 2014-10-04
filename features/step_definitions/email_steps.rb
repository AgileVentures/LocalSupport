And(/^an email should be sent to "(.*?)" as notification of the request$/) do |email|
  mails = ActionMailer::Base.deliveries
  expect(mails).not_to be_empty
  tos = mails.map {|m| m.to}
  expect(tos).to include [email]
end

And /^I should receive a "(.*?)" email$/ do |arg1|
  if arg1 == "Confirmation instructions"
    @email = ActionMailer::Base.deliveries[-2]
    ActionMailer::Base.deliveries.size.should eq 2
  else
    @email = ActionMailer::Base.deliveries.last
    ActionMailer::Base.deliveries.size.should eq 1
  end
    @email.subject.should include(arg1)
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


