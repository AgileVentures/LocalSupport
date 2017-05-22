Then(/^I should see "([^"]*)" in the response field for "([^"]*)"$/) do |msg, org_name|
  org = Organisation.find_by_name(org_name)
  id = org.id
  response = within("##{id}") { find('.response') }
  raise "Expected '#{msg}' but instead found '#{response.text}'" unless (response.text == msg)
end

Given(/^I check the box for "(.*?)"$/) do |org_name|
  org = Organisation.find_by_name(org_name)
  id = org.id
  within("##{id}") { find('input').set(true) }
end

Then(/^all the checkboxes should be (un)?checked$/) do |negate|
  expectation = negate ? :should_not : :should
  all('input[type="checkbox"]').each { |box| box.send(expectation, be_checked) }
end

Given(/^the superadmin invited a user for "(.*?)"$/) do |organisation_name|
  current_user = User.find_by_superadmin true
  org = Organisation.find_by_name(organisation_name)
  params = {
      :resend_invitation => 'true',
      :invite_list => {org.id => org.email}
  }
  BatchInviteJob.new(params, current_user).run
end

Then(/^I should see the preview email$/) do
  expect(page).to have_content "The Following email will be sent when a user is invited:"
end
