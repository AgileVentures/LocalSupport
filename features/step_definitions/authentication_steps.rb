Given /^I am signed in as a charity worker (un)?related to "(.*?)"$/ do |negate, organisation_name|
  organisation = Organisation.find_by_name(organisation_name)
  if negate
    users = User.where(superadmin: false)
    user = users.find { |user| user.organisation != organisation }
  else
    user = organisation.users.find { |user| !user.superadmin? }
  end
  page.set_rack_session("warden.user.user.key" => User.serialize_into_session(user).unshift("User"))
end
 
Given /^I am signed in as a (non-)?siteadmin$/ do |negate|
  user = User.find_by(siteadmin: negate ? false : true)
  page.set_rack_session("warden.user.user.key" => User.serialize_into_session(user).unshift("User"))
end
Given /^I am signed in as an? (non-)?superadmin$/ do |negate|
  user = User.find_by_superadmin(negate ? false : true)
  page.set_rack_session("warden.user.user.key" => User.serialize_into_session(user).unshift("User"))
end

Given /^I am signed in as a pending admin of "(.*?)"$/ do |org_name|
  org = Organisation.find_by_name org_name
  user = User.find_by_pending_organisation_id(org.id)
  page.set_rack_session("warden.user.user.key" => User.serialize_into_session(user).unshift("User"))
end

Given /^I sign up as "(.*?)" with password "(.*?)" and password confirmation "(.*?)"( on the legacy sign up page)?$/ do |email, password, password_confirmation, legacy|
  if legacy
    within('#new_user') do
      fill_in "user_email", :with => email
      fill_in "user_password", :with => password
      fill_in "user_password_confirmation", :with => password_confirmation
      click_button "Sign up"
    end
  else
    within('.dropdown-menu') do
      fill_in "signup_email", :with => email
      fill_in "signup_password", :with => password
      fill_in "signup_password_confirmation", :with => password_confirmation
      click_button "Sign up"
    end
  end
end

Given /^that I am logged in as any user$/ do
  steps %Q{
     Given the following users are registered:
   | email             | password | confirmed_at         |
   | registered_user@example.com | pppppppp | 2007-01-01  10:00:00 |
  }
  steps %Q{
    Given I visit the home page
    And I sign in as "registered_user@example.com" with password "pppppppp"
  }
end

Then /^I should not be signed in as any user$/ do
  steps %Q{
    Given I visit the new organisation page
    Then I should not see "Signed in as"
  }
end

When /^I sign out$/ do
  click_link 'Log out'
end

Given /^I sign in as "(.*?)" with password "(.*?)"( with javascript)?$/ do |email, password, js|
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  if js
    page.find("#signin").trigger("click")
  else
    click_link_or_button "Sign in"
  end
end

When(/^I sign in as "(.*?)" with password "(.*?)" via email confirmation$/) do |email, password|
  user = User.find_by_email("#{email}")
  user.confirm!
  steps %Q{
    Given I visit the home page
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

Given(/^I receive a new password for "(.*?)"$/) do |email|
  steps %Q{
    Given I visit the home page
    And I follow "Forgot your password?"
    And I fill in "user_retrieval_email" with "#{email}" within the main body
    And I press "Send me reset password instructions"
    And I click on the retrieve password link in the email to "#{email}"
  }
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

