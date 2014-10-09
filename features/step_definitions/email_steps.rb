And(/^an email should be sent to "(.*?)" as notification of the request for admin status of "(.*?)"$/) do |email, org_name|
  message = "There is a User Waiting for Admin Approval to '#{org_name}'"
  mails = ActionMailer::Base.deliveries.select{|m| m.to.include? email}
  expect(mails).not_to be_empty
  bodys = mails.map{|m| m.body}.select{|body| body.include? message }
  expect(bodys).not_to be_empty
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


