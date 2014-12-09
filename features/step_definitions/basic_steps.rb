require 'webmock/cucumber'
require 'uri-handler'
include ApplicationHelper

Then(/^I should see the "(.*?)" image linked to "(.*?)"$/) do |image_alt, link|
  within("a[href='#{link}']") do
    find("img[@alt='#{image_alt}']").should_not be_nil
  end
end

Then(/^I should see the "(.*?)" image linked to contributors$/) do |image_alt|
  steps %{Then I should see the "#{image_alt}" image linked to "#{contributors_path}"}
end

Then /^I should see permission denied$/ do
  page.should have_content PERMISSION_DENIED
end

Then(/^the Admin menu has a valid (.*?) link$/) do |link|
  within('#menuAdmin > ul.dropdown-menu') do
    find('a', text: link).should_not be_nil
    click_link link
    current_path.should eq paths(link.downcase)
  end
end

Then /^"(.*?)" should be a charity admin for "(.*?)" charity$/ do |email, org|
  org = Organisation.find_by_name org
  usr = User.find_by_email(email)
  expect(usr).not_to be_nil
  expect(org.users).to include usr
end

Then /^I should see the cannot add non registered user "(.*?)" as charity admin message$/ do |email|
  page.should have_content "The user email you entered,'#{email}', does not exist in the system"
end

And /^I add "(.*?)" as an admin for "(.*?)" charity$/ do |admin_email, charity|
  steps %Q{ And I visit the edit page for the organisation named "#{charity}"}
  fill_in 'organisation_admin_email_to_add', :with => admin_email
  steps %Q{
  And I press "Update Organisation"}
end

Then /^I should see the no charity admins message$/ do
  expect(page).to have_content "This organisation has no admins yet"
end

Given /^I delete "(.*?)" charity$/ do |name|
  org = Organisation.find_by_name name
  page.driver.submit :delete, "/organisations/#{org.id}", {}
end

Then /^I should( not)? see an edit button for "(.*?)" charity$/ do |negate, name|
  expectation_method = negate ? :not_to : :to
  org = Organisation.find_by_name name
  expect(page).send(expectation_method, have_link('Edit', :href => edit_organisation_path(org.id)))
end

Then /^I should( not)? see an edit button for "(.*?)" volunteer opportunity$/ do |negate, title|
  expectation_method = negate ? :not_to : :to
  op = VolunteerOp.find_by_title title
  expect(page).send(expectation_method, have_link('Edit', :href => edit_volunteer_op_path(op.id)))
end

Then /^I should( not)? see "(.*?)" in the charity admin email$/ do |negate,email|
  expectation_method = negate ? :not_to : :to
  expect(page).send(expectation_method, have_selector('li', :text => email))
end

Then /^show me the page$/ do
  save_and_open_page
end

When /^I search for "(.*?)"$/ do |text|
  fill_in 'q', with: text
  click_button 'Submit'
end

Given (/^I fill in the new charity page validly$/) do
  stub_request_with_address("64 pinner road")
  fill_in 'organisation_address', :with => '64 pinner road'
  fill_in 'organisation_name', :with => 'Friendly charity'
end
Given (/^I fill in the new charity page validly including the categories:$/) do |categories_table|
  categories_table.hashes.each do |cat|
    steps %Q{
      And I check the category "#{cat[:name]}"
    }
  end
  stub_request_with_address("64 pinner road")
  fill_in 'organisation_address', :with => '64 pinner road'
  fill_in 'organisation_name', :with => 'Friendly charity'
end

Then /^the contact information should be available$/ do
  steps %Q{
    When I follow "Contact"
    Then I should see "Contact Info Email us: contact@voluntaryactionharrow.org.uk Phone Us: 020 8861 5894 Write to Us: The Lodge, 64 Pinner Road, Harrow, Middlesex, HA1 4HZ Find Us: On Social Media (Click Here)"
   }
end
Then /^the about us should be available$/ do
  steps %Q{
    When I follow "About Us"
    Then I should see "About Us Supporting groups in Harrow We are a not-for-profit workers co-operative who support people and not-for-profit organisations to make a difference in their local community by: Working with local people and groups to identify local needs and develop appropriate action. Providing a range of services that help organisations to succeed. Supporting and encouraging the growth of co-operative movement. How do we support? Find out here (VAH in a nutshell) What is a Workers Co-operative? A workers co-operative is a business owned and democratically controlled by their employee members using co-operative principles. They are an attractive and increasingly relevant alternative to traditional investor owned models of enterprise. (Click here for more details)"
  }
end
Given /^I update "(.*?)" charity address to be "(.*?)"( when Google is indisposed)?$/ do |name, address, indisposed|
  steps %Q{
    Given I visit the show page for the organisation named "#{name}"
    And I follow "Edit"
    And I edit the charity address to be "#{address}" #{indisposed ? 'when Google is indisposed' : ''}
    And I press "Update Organisation"
  }
end

Given(/^I edit the charity email of "(.*?)" to be "(.*?)"$/) do |name, email|
  steps %Q{
    Given I visit the show page for the organisation named "#{name}"
    And I follow "Edit"
    And I edit the charity email to be "#{email}"
    And I press "Update Organisation"
  }
end

Given /^I update "(.*?)" charity website to be "(.*?)"$/ do |name, url|
  steps %Q{
    Given I visit the show page for the organisation named "#{name}"
    And I follow "Edit"
    And I edit the charity website to be "#{url}"
    And I press "Update Organisation"
  }
end

Given /^I have created a new organisation$/ do
  steps %Q{
    Given I visit the home page
    And I follow "New Organisation"
    And I fill in the new charity page validly
    And I press "Create Organisation"
   }
end

Given /^I furtively update "(.*?)" charity address to be "(.*?)"$/ do |name, address|
  steps %Q{
    Given I am furtively on the edit charity page for "#{name}"
    And I edit the charity address to be "#{address}"
    And I press "Update Organisation"
  }
end

Given /^I edit the charity website to be "(.*?)"$/ do |url|
  fill_in('organisation_website', :with => url)
end

Given /^I edit the charity email to be "(.*?)"$/ do |email|
  fill_in('organisation_email', :with => email)
end

When /^I edit the charity address to be "(.*?)"$/ do |address|
  stub_request_with_address(address)
  fill_in('organisation_address', :with => address)
end

Then /^the website link for "(.*?)" should have a protocol$/ do |name|
  steps %{
    Given I visit the show page for the organisation named "#{name}"
  }
  website = Organisation.find_by_name(name).website
  website.should =~ /^http\:\/\//
  expect(page).to have_selector("a[href='#{website}']")
end

And /^"(.*?)" charity address is "(.*?)"$/ do |name, address|
  org = Organisation.find_by_name(name)
  expect(org.address).to eq(address)
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |name1, name2|
  str = page.body
  raise "Expected '#{name1}' first, but instead found '#{name2}' first" unless str.index(name1) < str.index(name2)
end

Then /^I should see the donation_info URL for "(.*?)"$/ do |name1|
  org1 = Organisation.find_by_name(name1)
  content = "Donate to #{org1.name} now!"
  page.should have_xpath %Q<//a[@href = "#{org1.donation_info}" and @target = "_blank" and contains(.,'#{content}')]>
end

Then /^the donation_info URL for "(.*?)" should refer to "(.*?)"$/ do |name, href|
  expect(page).to have_link "Donate to #{name} now!", :href => href
end

And /^the search box should contain "(.*?)"$/ do |arg1|
  expect(page).to have_xpath("//input[@id='q' and @value='#{arg1}']")
end

Then /^I should( not)? see the no results message$/ do |negate|
  expectation_method = negate ? :not_to : :to
  expect(page).send(expectation_method, have_content(SEARCH_NOT_FOUND))
end

Then /^I should not see any address or telephone information for "([^"]*?)" and "([^"]*?)"$/ do |name1, name2|
  org1 = Organisation.find_by_name(name1)
  org2 = Organisation.find_by_name(name2)
  page.should_not have_content org1.telephone
  page.should_not have_content org1.address
  page.should_not have_content org2.telephone
  page.should_not have_content org2.address
end

Given /^I update the "(.*?)"$/ do |name|
  org1 = Organisation.find_by_name(name)
  org1.address = "84 pinner road"
  org1.save!
end

Then /^I should not see any address or telephone information for "([^"]*?)"$/ do |name1|
  org1 = Organisation.find_by_name(name1)
  page.should_not have_content org1.telephone
  page.should_not have_content org1.address
end

Given /^I edit the donation url to be "(.*?)"$/ do |url|
  fill_in('organisation_donation_info', :with => url)
end

Then /^I should not see any edit or delete links$/ do
  page.should_not have_link "Edit"
  page.should_not have_link "Destroy"
end

Then /^I should not see any edit link for "([^"]*?)"$/ do |name1|
  page.should_not have_link "Edit"
end

Then /^I should see the external website link for "(.*?)" charity$/ do |org_name|
  org = Organisation.find_by_name org_name
  page.should have_xpath %Q<//a[@target = "_blank" and @href = "#{org.website}" and contains(.,'#{org.website}')]>
end

Then /^I should( not)? see a link with text "([^"]*?)"$/ do |negate, link|
  if negate
    page.should_not have_link link
  else
    page.should have_link link
  end
end

Then /^I should( not)? see a new organisations link/ do |negate|
  #page.should_not have_link "New Organisation", :href => new_organisation_path
  #page.should_not have_selector('a').with_attribute href: new_organisation_path
  expectation_method = negate ? :not_to : :to
  expect(page).send(expectation_method, have_xpath("//a[@href='#{new_organisation_path}']"))
end

Then /^I should see "([^"]*)", "([^"]*)" and "([^"]*)"$/ do |text1, text2, text3|
  expect(page).to have_content text1
  expect(page).to have_content text2
  expect(page).to have_content text3
end

Then /^I should see "([^"]*)" and "([^"]*)"$/ do |text1, text2|
  expect(page).to have_content text1
  expect(page).to have_content text2
end

Then /^I should( not)? see "((?:(?!before|").)+)"$/ do |negate, text|
  expectation_method = negate ? :not_to : :to
  expect(page).send(expectation_method, have_content(text))
end

Then(/^I should( not)? see a link or button "(.*?)"$/) do |negate, link|
  expectation_method = negate ? :not_to : :to
  expect(page).send(expectation_method, have_selector(:link_or_button, link))
end

Then(/^the navbar should( not)? have a link to (.*?)$/) do |negate, link|
  expectation_method = negate ? :not_to : :to
  within('#navbar') { expect(page).send(expectation_method, have_selector(:link_or_button, link)) }
end

Given /^I edit the charity address to be "(.*?)" when Google is indisposed$/ do |address|
  body = %Q({
"results" : [],
"status" : "OVER_QUERY_LIMIT"
})
  stub_request_with_address(address, body)
  fill_in('organisation_address', :with => address)
end

Then /^I should not see the unable to save organisation error$/ do
  page.should_not have_content "1 error prohibited this organisation from being saved:"
end

Then /^the address for "(.*?)" should be "(.*?)"$/ do |name, address|
  Organisation.find_by_name(name).address.should == address
end

When /^I fill in "(.*?)" with "(.*?)" within the navbar$/ do |field, value|
  within('#navbar') { fill_in(field, :with => value) }
end

When /^I fill in "(.*?)" with "(.*?)" within the main body$/ do |field, value|
  within('#main') { fill_in(field, :with => value) }
end

Given /^I create "(.*?)" org$/ do |name|
  page.driver.submit :post, "/organisations", :organisation => {:name => name}
end

Then /^"(.*?)" org should not exist$/ do |name|
  expect(Organisation.find_by_name name).to be_nil
end

Then(/^"(.*?)" should have email "(.*?)"$/) do |org, email|
  Organisation.find_by_name(org).email.should eq email
end

And /^I click "(.*)" on the "(.*)" page and stay there$/  do |link, org_name|
  steps %Q{
    And I visit the show page for the organisation named "#{org_name}"
    And I click "#{link}"
    Then I should be on the show page for the organisation named "#{org_name}"
  }
end


Given /^"(.*)"'s request status for "(.*)" should be updated appropriately$/ do |email, org_name|
  steps %Q{
      And "#{email}"'s request for "#{org_name}" should be persisted
      And I should see "You have requested admin status for #{Organisation.find_by_name(org_name).name}"
      And I should not see a link or button "This is my organisation"
    }
end

And /"(.*)"'s request for "(.*)" should be persisted/ do |email, org|
  user = User.find_by_email(email)
  org = Organisation.find_by_name(org)
  user.pending_organisation_id.should eq org.id
end

When(/^the URL should contain "(.*?)"$/) do |string|
  URI.parse(current_url).path.should == '/' + string
end

Then(/^I should see "(.*?)" < (.*?) >$/) do |text, tag|
  tags = {'emphasized' => 'em', 'stronged' => 'strong', 'number listed' => 'ol', 'bullet listed' => 'ul'}
  collect_tag_contents(page.body, tags[tag]).should include(text)
end

Then(/^I should see "(.*?)" < tagged > with "(.*?)"$/) do |text, tag|
  page.should have_css(tag, :text => text)
  #collect_tag_contents(page.body, tag).should include(text)
end

Then(/^I should see "(.*?)" < linked > to "(.*?)"$/) do |text, url|
  links = collect_links(page.body)
  links[text].should == url
end

Then(/^I should see a mail-link to "([^"]*)"$/) do |email|
  page.should have_css("a[href='mailto:#{email}']")
end

When /^I approve "(.*?)"$/ do |email|
  visit users_report_path
  page.body.should have_content(email)
  user_id = User.find_by_email(email).id
  within("tr##{user_id}") do
    click_link 'Approve'
  end
end

Then(/^"(.*?)" is a charity admin of "(.*?)"$/) do |user_email, org_name|
  user = User.find_by_email(user_email)
  org = Organisation.find_by_name(org_name)
  user.organisation.should == org
end

When /^I delete "(.*?)"$/ do |email|
  visit users_report_path
  page.body.should have_content(email)
  user_id = User.find_by_email(email).id
  within("tr##{user_id}") do
    click_link 'Delete'
  end
end
Then(/^user "(.*?)" should exist$/) do |user_email|
  visit users_report_path
  user_id = User.find_by_email(user_email).id
  find("tr##{user_id}", text: user_email).should_not be_nil
end
Then /^user "(.*?)" is( not)? deleted$/ do |email, negative|
  expectation = negative ? :not_to : :to
  expect(User.find_by_email email).send(expectation, be_nil)
end

And(/^I (un)?check "([^"]*)"$/) do |negate, css|
  box_state = negate ? :uncheck : :check
  page.send(box_state, css)
end

Given(/^the (.*?) for "(.*?)" has been marked (public|hidden)$/) do |field, name, mode|
  org = Organisation.find_by_name(name)
  publish = mode == 'hidden' ? false : true
  org.send("publish_#{field}=", publish)
  org.save!
end

Then /^I should( not)? see:$/ do |negative, table|
  expectation = negative ? :should_not : :should
  table.rows.flatten.each do |string|
    page.send(expectation, have_text(string))
  end
end

Then /^the index should( not)? contain:$/ do |negative, table|
  expectation = negative ? :should_not : :should
  table.raw.flatten.each do |cell|
    within('#column2') do
      page.send(expectation, have_text(cell))
    end
  end
end

Then(/^I should see "([^"]*)" page before "([^"]*)"$/) do |first_item, second_item|
  page.body.should =~ /#{first_item}.*#{second_item}/m
end

Given /^"(.*?)" has a whitespace at the end of the email address$/ do |org_name|
  org = Organisation.find_by_name(org_name)
  org.email += ' '
  org.save
end

Given /^associations are destroyed for:$/ do |table|
  table.rows.flatten.each do |org_name|
    org = Organisation.find_by_name org_name
    user = org.users.pop
    org.save
    user.organisation_id = nil
    user.save
  end
end

Given /^debugger$/ do
  debugger
  puts ""
end
Given /^I run the invite migration$/ do

end


Given(/^I can run the rake task "(.*?)"$/) do |task|
  stdout, stderr, status = Open3.capture3("#{task}")
  expect(stderr).not_to include "Error"
  expect(status).to be_success
end
