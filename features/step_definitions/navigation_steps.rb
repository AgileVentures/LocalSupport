Given /^I am on the home page$/ do
  visit "/"
end
And /^I select the "(.*?)" category$/ do |category|
  select(category, :from => "category[id]")
end

When(/^I visit "(.*?)"$/) do |path|
  visit path
end

def paths
  {
      'home' => root_path,
      'sign up' => new_user_registration_path,
      'sign in' => new_user_session_path,
      'organisations index' => organizations_path,
      'contributors' => contributors_path,
      'password reset' => edit_user_password_path,
      'invitation' => accept_user_invitation_path,
      'organisations without users' => organizations_report_path,
      'all users' => users_report_path,
      'invited users' => invited_users_report_path,
      'volunteer opportunities' => volunteer_ops_path
  }
end

Then /^I visit the (.*) page$/ do |location|
  location = location.downcase
  raise "No matching path found for #{location}" if paths[location].nil?
  visit paths[location]
end

Then /^I visit the (.*) page for organization "(.*?)"$/ do |location, organization|
  org = Organization.find_by_name organization
  case location
    when "new volunteer opportunity" then visit new_volunteer_op_path
    when "show volunteer opportunity" then visit volunteer_op_path(org)
    else raise "No matching path found for #{location}!"
  end
end

Then /^I should be on the (.*) page$/ do |location|
  location = location.downcase
  raise "No matching path found for #{location}" if paths[location].nil?
  current_path.should eq paths[location]
end

Then /^I should be on the (.*) page for organization "(.*?)"$/ do |location, organization|
  org = Organization.find_by_name organization
  case location
    when "new volunteer opportunity" then current_path.should == new_volunteer_op_path
    when "show volunteer opportunity" then current_path.should == volunteer_op_path(org)
    else raise "No matching path found for #{location}!"
  end
end

Given(/^I try to access "(.*?)" page$/) do |page|
  visit("/#{page}")
end

And(/^the page should be titled "(.*?)"$/) do |title|
  page.should have_selector("title", title)
end

And (/^I should see a full width layout$/) do
  within('#content') do
    page.should have_css('#one_column.span12')
  end
end

And (/^I should see a two column layout$/) do
  within('#content') do
    page.should have_css('#column1.span6')
    page.should have_css('#column2.span6')
  end
end


Then(/^the response status should be 404$/) do
  page.status_code.should == 404
  #page.response_code.should be 404
end

Then(/^I should be on the edit page for "(.*?)"$/) do |permalink|
  pg = Page.find_by_permalink(permalink)
  current_path.should eq( edit_page_path (pg.permalink ))
end

Given /^I press "(.*?)"$/ do |button|
  click_button(button)
end

When /^I click "(.*)"$/ do |link|
  click_link(link)
end

When /^I click id "(.*)"$/ do |id|
  find("##{id}").click
  wait_for_ajax
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
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
  within('#content') do
    page.should have_css('#column1.span6')
    page.should have_css('#column2.span6')
  end
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

Given(/^I am on the edit page with the "(.*?)" permalink$/) do |permalink|
  pg = Page.find_by_permalink(permalink)
  visit edit_page_path pg.permalink
end

Then(/^the "([^"]*)" should be (not )?visible$/) do |id, negate|
  # http://stackoverflow.com/a/15782921
  # Capybara "visible?" method(s) are inaccurate!

  #regex = /height: 0/ # Assume style="height: 0px;" is the only means of invisibility
  #style = page.find("##{id}")['style']
  #sleep 0.25 if style   # need to give js a moment to modify the DOM
  #expectation = negate ? :should : :should_not
  #style ? style.send(expectation, have_text(regex)) : negate.nil?

  elem = page.find("##{id}")
  negate ? !elem.visible? : elem.visible?
end

Then(/^the "([^"]*)" should be "([^"]*)"$/) do |id, css_class|
    page.should have_css("##{id}.#{css_class}")
end

When(/^I click link with id "([^"]*)"$/) do |id|
  page.find("##{id}").click
end
When(/^javascript is enabled$/) do
  Capybara.javascript_driver
end


And(/^I click tableheader "([^"]*)"$/) do |name|
  find('th', :text => "#{name}").click
  wait_for_ajax
end

Given(/^I am on the volunteer opportunities page$/) do
  visit '/volunteer_ops'
end

Then(/^navbar button "(.*?)" should( not)? be active$/) do |button_text, negative|
  expectation_method = negative ? :should_not : :should
  within('.nav.nav-pills.pull-right') do |buttons|
    page.send(expectation_method, have_css('li.active > a', :text => "#{button_text}"))
  end
end
