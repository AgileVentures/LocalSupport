And /^a "(.*?)" email should be sent to "(.*?)"$/ do |arg1, arg2|
  debugger
  @email = ActionMailer::Base.deliveries.last
  @email.to.should include (arg2)
  @email.subject.should include(arg1)
  ActionMailer::Base.deliveries.size.should eq 1
  ActionMailer::Base.deliveries.clear
end

And /^I should not receive an email$/ do
  debugger
  ActionMailer::Base.deliveries.size.should eq 0
  ActionMailer::Base.deliveries.clear
end

