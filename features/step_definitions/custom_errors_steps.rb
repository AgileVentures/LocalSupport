And(/^the response status should be "([^"]*)"$/) do |status_code|
  page.status_code.should eq status_code.to_i
end

When(/^I encounter an internal server error$/) do
  PagesController.any_instance.should_receive(:show).and_raise(Exception)
  visit '/totally-random-path'
end
