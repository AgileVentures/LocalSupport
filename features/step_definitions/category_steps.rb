Then(/^I should see the category named (.*) as the (.*) category in (.*)$/) do |category, nth, heading|
  page.should have_xpath("//div/strong/em[text()='#{heading}']/../../following-sibling::div[#{nth[0..-3]}]/label[text()='#{category}']")
end

Then (/the category named (.*) should be (checked|unchecked)$/) do |category, status|
  assertion = (status == 'checked') ? :should : :should_not
  page.find(:xpath, "//div/label[text()='#{category}']/preceding-sibling::input[1]").send(assertion, be_checked)
end

Then(/^I check the category "(.*?)"$/) do |category|
  id = Category.find_by_name(category).id
  within '#categories_scroll' do
    find("input[value='#{id}']").set(true)
  end
end
Then(/^I uncheck the category "(.*?)"$/) do |category|
  id = Category.find_by_name(category).id
  within '#categories_scroll' do
    find("input[value='#{id}']").set(false)
  end
end


