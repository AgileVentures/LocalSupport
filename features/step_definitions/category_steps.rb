Then(/^I should see the category named (.*) as the (.*) category in (.*)$/) do |category, nth, heading|
  page.should have_xpath("//*[contains(., '#{heading}')]/following-sibling::*[not(self::input) and #{nth[0..-3]}]//label[text()[contains(.,'#{category}')]]")
end

Then (/the category named (.*) should be (checked|unchecked)$/) do |category, status|
  assertion = (status == 'checked') ? :should : :should_not
  page.has_checked_field?("#{category}").send(assertion, be_truthy)
end

Then(/^I check the category "(.*?)"$/) do |category_name|
  within '.org-categories' do
    check(category_name)
  end
end

Then(/^I uncheck the category "(.*?)"$/) do |category_name|
  within '.org-categories' do
    uncheck(category_name)
  end
end

Then(/^the "(.*?)" category should be selected from (What They Do|How They Help|Who They Help)$/) do |name, cat_type|
  cat_id = case cat_type
    when 'What They Do'
      '#what_id'
    when 'How They Help'
      '#how_id'
    when 'Who They Help'
      '#who_id'
    else
      raise "Unsupported category type"
  end
  id = Category.find_by(name: name).id.to_s
  find(cat_id).value.should eq id
end

Then(/^the default all value should be selected from What They Do$/) do
  expect(find("#what_id").value).to be_empty
end

Then(/^the default all value should be selected from Who They Help$/) do
  expect(find("#who_id").value).to be_empty
end

Then(/^the default all value should be selected from How They Help$/) do
  expect(find("#how_id").value).to be_empty
end
