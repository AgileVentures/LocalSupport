Then(/^I should see "([^"]*)" in the response field for "([^"]*)"$/) do |msg, org_name|
  org = Organization.find_by_name(org_name)
  id = org.id
  response = within("##{id}") { find('.response') }
  raise "Expected '#{msg}' but instead found '#{response.text}'" unless (response.text == msg)
end

Given(/^I check the box for "(.*?)"$/) do |org_name|
  org = Organization.find_by_name(org_name)
  id = org.id
  within("##{id}") { find('input').set(true) }
end

Then(/^all the checkboxes should be (un)?checked$/) do |negate|
  expectation = negate ? :should_not : :should
  all('input[type="checkbox"]').each { |box| box.send(expectation, be_checked) }
end

Given(/^the admin invited a user for "(.*?)"$/) do |organization_name|
  current_user = User.find_by_admin true
  org = Organization.find_by_name(organization_name)
  invite_list = [{:id => org.id, :email => org.email}]
  ::Invitations::BatchInviteJob.(true, invite_list, current_user)
end
