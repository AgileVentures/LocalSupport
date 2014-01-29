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
  response = within("##{id}") { find('.response') }
  raise "Expected '#{token}' but instead found '#{response.text}'" unless (response.text == token)
end


Then(/^I should see "([^"]*)" in the response field for "([^"]*)"$/) do |msg, org_name|
  org = Organization.find_by_name(org_name)
  id = org.id
  response = within("##{id}") { find('.response') }
  raise "Expected '#{msg}' but instead found '#{response.text}'" unless (response.text == msg)
end