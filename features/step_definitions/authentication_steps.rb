Given /^I sign up as "(.*?)" with password "(.*?)" and password confirmation "(.*?)"$/ do |email, password,password_confirmation|
  fill_in "Email" , :with => email
  fill_in "charity_worker_password" , :with => password
  fill_in "charity_worker_password_confirmation" , :with => password_confirmation
  click_button "Sign up"
end

Given /^the following users are registered:$/ do |charity_workers_table|
  charity_workers_table.hashes.each do |charity_worker|
    CharityWorker.create! charity_worker
  end
end

Given /^that I am logged in as any user$/ do
  steps %Q{
     Given the following users are registered:
   | email             | password |
   | jcodefx@gmail.com | pppppppp |
  } 
  steps %Q{
    Given I am on the sign in page
    And I sign in as "jcodefx@gmail.com" with password "pppppppp"
  }
end

Then /^I should not be signed in as any user$/ do
  steps %Q{
    Given I am on the new charity page
    Then I should not see "Signed in as"
  }
end

When /^I sign out$/ do
  click_link 'Sign Out' 
end

Then /^I should be on the sign in page$/ do
  current_path.should == new_charity_worker_session_path
end

Given /^I sign in as "(.*?)" with password "(.*?)"$/ do |email, password|
  fill_in "Email" , :with => email
  fill_in "Password" , :with => password
  click_button "Sign in"
end

Given /^I am on the sign in page$/ do
  visit new_charity_worker_session_path
end

Given /^I am on the sign up page$/ do
  visit new_charity_worker_registration_path
end
