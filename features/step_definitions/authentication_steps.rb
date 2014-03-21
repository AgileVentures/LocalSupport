Given /^I am signed in as a charity worker (un)?related to "(.*?)"$/ do |negate, organization_name|
  organization = Organization.find_by_name(organization_name)
  if negate
    users = User.find_all_by_admin(false)
    user = users.find { |user| user.organization != organization }
  else
    user = organization.users.find { |user| !user.admin? }
  end
  page.set_rack_session("warden.user.user.key" => User.serialize_into_session(user).unshift("User"))
end

Given /^I am signed in as an? (non-)?admin$/ do |negate|
  user = User.find_by_admin(negate ? false : true)
  page.set_rack_session("warden.user.user.key" => User.serialize_into_session(user).unshift("User"))
end

Given /^I sign up as "(.*?)" with password "(.*?)" and password confirmation "(.*?)"$/ do |email, password, password_confirmation|
  fill_in "signup_email", :with => email
  fill_in "signup_password", :with => password
  fill_in "signup_password_confirmation", :with => password_confirmation
  click_button "Sign up"
end

Given /^I sign in as a charity worker with permission to edit "(.*?)"$/ do |name|
  org = Organization.find_by_name name
  org.users # TODO we will want some habtm to support this eventually
end

And /^I am signed in as the admin using password "(.*?)"$/ do |password|
  admin = User.find_by_admin(true)
  steps %Q{
    Given I am on the sign in page
    And I sign in as "#{admin.email}" with password "#{password}"
  }
end

And /^I am not signed in as the admin using password "(.*?)"$/ do |password|
  admin = User.find_by_admin(false)
  steps %Q{
    Given I am on the sign in page
    And I sign in as "#{admin.email}" with password "#{password}"
  }
end

#TODO: Should we bypass mass assgiment in the creation via :without_protection?
Given /^the following users are registered:$/ do |users_table|
  users_table.hashes.each do |user|
    user["admin"] = user["admin"] == "true"
    user["organization"] = Organization.find_by_name(user["organization"])
    user["pending_organization"] = Organization.find_by_name(user["pending_organization"])
    worker = User.create! user, :without_protection => true
  end
end

Given /^that I am logged in as any user$/ do
  steps %Q{
     Given the following users are registered:
   | email             | password | confirmed_at         |
   | registered_user@example.com | pppppppp | 2007-01-01  10:00:00 |
  }
  steps %Q{
    Given I am on the home page
    And I sign in as "registered_user@example.com" with password "pppppppp"
  }
end

Then /^I should not be signed in as any user$/ do
  steps %Q{
    Given I am on the new charity page
    Then I should not see "Signed in as"
  }
end

When /^I sign out$/ do
  click_link 'Log out'
end

Given /^I sign in as "(.*?)" with password "(.*?)"$/ do |email, password|
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_link_or_button "Sign in"
end

Given /^I am on the sign up page$/ do
  step "I am on the home page"
  expect(page).to have_field('signup_email')
  expect(page).to have_field('signup_password')
  expect(page).to have_button('signup')
end

Given(/^I am on the password reset page$/) do
  visit edit_user_password_path(reset_password_token: "18217tiegi1qwea")
end

When(/^I sign in as "(.*?)" with password "(.*?)" via email confirmation$/) do |email, password|
  user = User.find_by_email("#{email}")
  user.confirm!
  steps %Q{
    Given I am on the home page
    And I sign in as "#{email}" with password "#{password}"
  }
end

Given /^I have a "([^\"]+)" cookie set to "([^\"]+)"$/ do |key, value|
  headers = {}
  Rack::Utils.set_cookie_header!(headers, key, value)
  cookie_string = headers['Set-Cookie']
  Capybara.current_session.driver.browser.set_cookie(cookie_string)
end

And(/^cookies are approved$/) do
  steps %Q{And I have a "cookie_policy_accepted" cookie set to "true"}
end

And(/^cookies are not approved$/) do
  steps %Q{And I have a "cookie_policy_accepted" cookie set to "false"}
end

Given(/^I click on the confirmation link in the email to "([^\"]+)"$/) do |email|
  user = User.find_by_email email
  visit confirmation_url(user.confirmation_token)
end

Given(/^I click on the retrieve password link in the email to "([^\"]+)"$/) do |email|
  user = User.find_by_email email
  visit password_url(user.reset_password_token)
end

Given(/^I click on the invitation link in the email to "([^\"]+)"$/) do |email|
  user = User.find_by_email email
  visit invitation_url(user.invitation_token)
  step "I should be on the invitation page"
end

And(/^I accepted the cookie policy from the "([^\"]+)" page$/) do |page|
  step %Q{I click "Close"}
  step "I should be on the #{page} page"
end

And(/^I set my password/) do
  step %Q{I fill in "user_password" with "12345678" within the main body}
  step %Q{I fill in "user_password_confirmation" with "12345678" within the main body}
  step %Q{I press "Set my password"}
end

