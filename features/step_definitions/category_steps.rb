Then(/^I should see the category named (.*) as the (.*) category in (.*)$/) do |category, nth, heading|
  page.should have_xpath("//div/strong/em[text()='#{heading}']/../../following-sibling::div[#{nth[0..-3]}]/label[text()='#{category}']")
end

Then (/the category named (.*) should be (checked|unchecked)$/) do |category, status|
  assertion = (status == 'checked') ? :should : :should_not
  page.find(:xpath, "//div/label[text()='#{category}']/preceding-sibling::input[1]").send(assertion, be_checked)
end

Then(/^I check the category "(.*?)"$/) do |category_name|
  within '#categories_scroll' do
    find(:xpath,"//div/label[text()='#{category_name}']/preceding-sibling::input[1]").set(true)
  end
end
Then(/^I uncheck the category "(.*?)"$/) do |category_name|
  within '#categories_scroll' do
    find(:xpath,"//div/label[text()='#{category_name}']/preceding-sibling::input[1]").set(false)
  end
end

Then(/^the "(.*?)" category should be selected from What They Do$/) do |name|
  id = Category.find_by(name: name).id.to_s
  find("#what_id").value.should eq id
end

Then(/^the "(.*?)" category should be selected from How They Help$/) do |name|
  id = Category.find_by(name: name).id.to_s
  find("#how_id").value.should eq id
end

Then(/^the "(.*?)" category should be selected from Who They Help$/) do |name|
  id = Category.find_by(name: name).id.to_s
  find("#who_id").value.should eq id
end