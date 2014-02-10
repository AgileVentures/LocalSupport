When(/^I click Generate User button for "([^"]*)"$/) do |org_name|
  id = Organization.find_by_name(org_name).id
  within("##{id}") { find('.generate_user').click }
  sleep 1
end

Then(/^a token should be in the response field for "([^"]*)"$/) do |org_name|
  org = Organization.find_by_name(org_name)
  id = org.id
  user = org.users.first
  token = user.reset_password_token
  url = Capybara.current_host + retrieve_password_url(token)
  response = within("##{id}") { find('.response') }
  raise "Expected '#{url}' but instead found '#{response.text}'" unless (response.text == url)
end


Then(/^I should see "([^"]*)" in the response field for "([^"]*)"$/) do |msg, org_name|
  org = Organization.find_by_name(org_name)
  id = org.id
  response = within("##{id}") { find('.response') }
  raise "Expected '#{msg}' but instead found '#{response.text}'" unless (response.text == msg)
end