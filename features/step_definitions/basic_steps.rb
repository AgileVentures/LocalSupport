Given /^I am on the home page$/ do
  visit "/"
end

When /^I search for "(.*?)"$/ do |text|
  fill_in 'search', with: text
  click_button 'search'
end

Then /^I should see contact details for "(.*?)"$/ do |text|
  page.should have_content text
end

Then /^I should see contact details for "(.*?)" and "(.*?)"$/ do |text1, text2|
  page.should have_content text1
  page.should have_content text2
end

