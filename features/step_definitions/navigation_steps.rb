Given /^I am on the home page$/ do
  visit "/"
end
And /^I select the "(.*?)" category$/ do |category|
  select(category, :from => "category[id]")
end
Then /^I should be on the home page$/ do
  current_path.should == root_path()
end
Given /^I am on the charity search page$/ do
  visit organizations_search_path
end

Then /^I should be on the charity page for "(.*?)"$/ do |charity_name|
  charity = Organization.find_by_name(charity_name)
  expect(current_path).to eq(organization_path charity.id) 
end

Then /^following Disclaimer link should display Disclaimer$/ do
  steps %Q{
    When I follow "Disclaimer"
    Then I should see "Disclaimer"
    And I should see "Whilst Voluntary Action Harrow has made effort to ensure the information here is accurate and up to date we are reliant on the information provided by the different organisations. No guarantees for the accuracy of the information is made."
  }
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
  visit organization_path org1.id
  click_link 'Edit'
end

Given /^I am furtively on the edit charity page for "(.*?)"$/ do |name|
  org = Organization.find_by_name(name)
  visit edit_organization_path org.id
end
