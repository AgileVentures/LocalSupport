And /^I should receive a "(.*?)" email$/ do |arg1|
  @email = ActionMailer::Base.deliveries.last
  debugger
  @email.subject.should include(arg1)
  ActionMailer::Base.deliveries.size.should eq 1
  ActionMailer::Base.deliveries.clear
end

And /^I should not receive an email$/ do
  debugger
  ActionMailer::Base.deliveries.size.should eq 0
  ActionMailer::Base.deliveries.clear
end

