regex = /^I submit a volunteer op "(.*?)", "(.*?)" on the "(.*?)" page$/
And(regex) do |title, desc, org_name|
  org = Organisation.find_by_name(org_name)
  visit organisation_path org
  click_link "Create a Volunteer Opportunity"
  expect(current_path).to eq new_organisation_volunteer_op_path org
  fill_in 'Title', :with => title
  fill_in 'Description', :with => desc
  click_on 'Create a Volunteer Opportunity'
end

Given(/^I submit a volunteer op with address on the org page/) do |volunteer_ops_table|
  volunteer_ops_table.hashes.each do |volunteer_op|
    org = Organisation.find_by_name(volunteer_op['org_name'])
    visit organisation_path org
    click_link 'Create a Volunteer Opportunity'
    expect(current_path).to eq new_organisation_volunteer_op_path org
    fill_in 'Title', with: volunteer_op['title']
    fill_in 'Description', with: volunteer_op['desc']
    fill_in 'Address', with: volunteer_op['address']
    fill_in 'Postcode', with: volunteer_op['postcode']
    click_on 'Create a Volunteer Opportunity'
  end
end

regex = /^I run the import doit service( with a radius of (\d+\.?\d*) miles)?$/
Given(regex) do |override, radius|
  if override
    ImportDoItVolunteerOpportunities.with radius.to_f
  else
    ImportDoItVolunteerOpportunities.with
  end
end

Given(/^there is a doit volunteer op named "(.*?)"$/) do |title|
  VolunteerOp.create(title: title,
                     description: 'description content',
                     source: 'doit',
                     organisation_id: 1)
end

Then(/^the doit volunteer op named "(.*?)" should be deleted$/) do |title|
  expect(VolunteerOp.find_by_title(title)).to eq nil
end

Then(/^there should be (\d+) doit volunteer ops stored$/) do |count|
  expect(VolunteerOp.where(source: 'doit').count).to eq count.to_i
end

Then(/^all imported volunteer ops have latitude and longitude coordinates$/) do
  VolunteerOp.where(source: 'doit').all? do |op|
    expect(op).to have_coordinates
  end
end

Given(/^that the (.+) flag is (enabled|disabled)$/) do |feature, state|
  if f = Feature.find_by_name(feature) then
    f.update_attributes(active: (state == 'enabled'))
  else
    Feature.create!(name: feature, active: (state == 'enabled'))
  end
end

Given /^I update "(.*?)" volunteer op description to be "(.*?)"$/ do |title, description|
  vop = VolunteerOp.find_by_title title
  visit volunteer_op_path vop
  click_on 'Edit'
  fill_in('Description', :with => description)
  click_on 'Update a Volunteer Opportunity'
end

Given /^I should see (\d+) markers in the map$/ do |num|
  expect(page).to have_css('.vol_op', count: num)
end

Then(/^I should see a link to "(.*?)" page "(.*?)"$/) do |link, url|
  page.should have_link(link, :href => url)
end

When(/^I set new volunteer opportunity location to "(.*?)", "(.*?)"$/) do |addr, pc|
  fill_in 'Address', with: addr
  fill_in 'Postcode', with: pc
  click_button 'Update a Volunteer Opportunity'
end

regex = /^I should see "(.*?)", "(.*?)", "(.*?)" and "(.*?)"$/
Then(regex) do |title, desc, address, org|
  expect(page).to have_content title
  expect(page).to have_content desc
  expect(page).to have_content address
  expect(page).to have_content org
end

Then(/^I should open "(.*?)" in a new window$/) do |organisation|
  number_of_windows = -> { page.driver.browser.window_handles.count }
  expect { click_link(organisation) }.to change(&number_of_windows).by 1
end

Then(/^the Do-it word in the legend should be a hyperlink to the Do-it website$/) do
  within('.map_legend') do
    first, _, third = all('.key_text').to_a

    expect(first).to have_link('Do-it', href: 'https://do-it.org/')
    expect(third).to have_link('Do-it', href: 'https://do-it.org/')
  end
end

Then(/^I should see a search form$/) do
  expect(page).to have_css('form.volunteer-ops-search')
end

Given(/^I fill additional fields required by Doit$/) do
  select("Help Out Harrow!", from: 'doit_volunteer_op_doit_org_id')
  fill_in('Advertise start date', with: '2017-03-01')
  fill_in('Advertise end date', with: '2017-04-01')

end
