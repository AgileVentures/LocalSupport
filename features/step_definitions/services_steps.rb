Given('the following services exist:') do |table|
  table.hashes.each do |service|
    service['organisation'] = Organisation.find_by_name(service['organisation'])
    Service.create! service
  end
end

Given('the following self care categories exist:') do |table|
  table.hashes.each do |self_care_category|
    SelfCareCategory.create! self_care_category
  end
end

Then(/^'(.*?)' is (still )?set to '(.*?)'$/) do |select, _, value|
  expect(page).to have_select(select_id(select), selected: value)
end

And(/^no '(.*?)' (is|are) (still )?selected$/) do |select, _, _|
  expect(page).to have_select(select_id(select), selected: nil)
end

When(/^I select '(.*?)' from '(.*?)'/) do |value, select|
  select(value, from: select_id(select))
end 

def select_id(name)
  {
    'Type of Activity': 'activity_type',
    'Location': 'where_we_work',
    'Self Care Categories': 'self_care_category_id',
  }[name.to_sym]
end

Given(/^I should( .*)? see the "(.*)"/) do |negate, element|
  if negate.nil?
    expect(page).to have_selector(element)
  elsif negate.strip == 'not'
    expect(page).not_to have_selector(element)
  end
end
