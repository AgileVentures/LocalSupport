Then(/^I should see the category named (.*) as the (.*) category in (.*)$/) do |category, nth, heading|
  page.should have_xpath("//div/strong/em[text()='#{heading}']/../../following-sibling::div[#{nth[0..-3]}]/label[text()='#{category}']")
end

Then (/^(.*) should be (checked|unchecked)$/) do |category, status|
  assertion = (status == 'checked') ? :should : :should_not
  page.find(:xpath, "//div/label[text()='#{category}']/preceding-sibling::input[1]").send(assertion, be_checked)
end
