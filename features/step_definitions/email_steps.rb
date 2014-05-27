And /^I should receive a "(.*?)" email$/ do |arg1|
  @email = ActionMailer::Base.deliveries.last
  @email.subject.should include(arg1)
  ActionMailer::Base.deliveries.size.should eq 1
end

And(/^an email with subject line "([^"]*)" should have been sent$/) do |arg|
  @email = ActionMailer::Base.deliveries.last
  @email.subject.should include(arg)
  #@email.cc.should_not be_nil
  #@email.cc.include('technical@harrowcn.org.uk')     # we want this but not clear how to do with invitation
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

# attemping to copy https://github.com/mtc2013/LocalSupport/blob/targeted_invites/features/step_definitions/email_steps.rb
require 'rake'
Given(/^I run the "(.*?)" rake task located at "(.*?)"$/) do |task, loc|
  @rake = Rake::Application.new
  Rake.application = @rake
  # HACK TO BE FIXED.
  # This require fails second time around (usually in cucumber batch test)
  # because file is added to loaded list, and then can't be re-required
  # however this has side effect of not adding the files tasks to @rake
  # by explicitly overriding the loaded list we force a reload and get the
  # tasks pulled in - not sure what other side effects there might be
  Rake.application.rake_require loc, ['lib'], ''
  Rake::Task.define_task(:environment)
  @rake[task].invoke
end
