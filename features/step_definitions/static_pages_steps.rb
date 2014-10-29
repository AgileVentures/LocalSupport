Then(/^I should be on the edit page for "(.*?)"$/) do |permalink|
  pg = Page.find_by_permalink(permalink)
  current_path.should eq( edit_page_path (pg.permalink ))
end

Then /^following Disclaimer link should display Disclaimer$/ do
  steps %Q{
    When I follow "Disclaimer"
    Then I should see "Disclaimer"
    And I should see "Whilst Voluntary Action Harrow has made effort to ensure \
the information here is accurate and up to date we are reliant on the \
information provided by the different organisations. No guarantees for the \
accuracy of the information is made."
  }
end

Given(/^I am on the edit page with the "(.*?)" permalink$/) do |permalink|
  pg = Page.find_by_permalink(permalink)
  visit edit_page_path pg.permalink
end

Given(/^I visit the pages manager$/) do
  steps %Q{
    When I am on the home page
    And I follow "About HCN"
    And I follow "Pages"}
end

Given(/^I remove "(.*?)" from the footer$/) do |permalink|
  # this finder relies on the permalink text _only_ appearing in one
  # row of the page under test
  find("tr[contains('#{permalink}')]").click_link_or_button('Hide link')
end

Then(/^the "(.*?)" link is not in the footer$/) do |link|
  expect(page.has_xpath? "//footer//a[@href=\"\/#{link}\"]").to be false
end

Then(/^the "(.*?)" link is in the footer$/) do |link|
  expect(page.has_xpath? "//footer//a[@href=\"\/#{link}\"]").to be true
end

And(/^I add "(.*?)" to the footer$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

