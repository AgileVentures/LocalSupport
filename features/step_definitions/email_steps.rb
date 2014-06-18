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

def stub_request_with_address(address, body = nil)
  filename = "#{address.gsub(/\s/, '_')}.json"
  filename = File.read "test/fixtures/#{filename}"
  stub_request(:any, /maps\.googleapis\.com/).
      to_return(status => 200, :body => body || filename, :headers => {})
end

Given /Google is indisposed for "(.*)"/ do |address|
  body = %Q({
"results" : [],
"status" : "OVER_QUERY_LIMIT"
})
  stub_request_with_address(address, body)
end
