Given /^I am on the home page$/ do
  visit "/"
end

Then /^I should be on the home page$/ do
  current_path.should == root_path()
end
Given /^I am on the charity search page$/ do
  visit organizations_search_path
end

Given /^I am on the new charity page$/ do
  visit new_organization_path
end

Then /^I should be on the new charity page$/ do
 current_path.should == new_organization_path
end

Given /^I am on the charity page for "(.*?)"$/ do |name1|
  org1 = Organization.find_by_name(name1)
  visit organization_path org1.id
end

Given /^I am on the edit charity page for "(.*?)"$/ do |name1|
  org1 = Organization.find_by_name(name1)
  visit edit_organization_path org1.id
end
