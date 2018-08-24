regex = /^I submit a volunteer op "(.*?)", "(.*?)" on the "(.*?)" page$/
And(regex) do |title, desc, org_name|
  org = Organisation.find_by_name(org_name)
  visit organisation_path org
  click_link "Create a Volunteer Opportunity"
  expect(current_path).to eq new_organisation_volunteer_op_path org
  fill_in 'Title', :with => title
  fill_in 'Description', :with => desc
  expect_any_instance_of(TwitterApi).to receive(:tweet).once
  click_on 'Create a Volunteer Opportunity'
end

Given /^I submit a blank volunteer op on the "(.*?)" page$/ do |org_name|
  org = Organisation.find_by_name(org_name)
  visit organisation_path org
  click_link "Create a Volunteer Opportunity"
  expect(current_path).to eq new_organisation_volunteer_op_path org
  click_on 'Create a Volunteer Opportunity'
end

When("I submit a valid volunteer opportunity") do
  org = Organisation.find_by_name('Friendly')
  visit organisation_path org
  click_link "Create a Volunteer Opportunity"
  expect(current_path).to eq new_organisation_volunteer_op_path org
  fill_in 'Title', :with => 'title'
  fill_in 'Description', :with => 'desc'
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
    fill_in 'Role description', with: volunteer_op['role_desc']
    fill_in 'Skills needed', with: volunteer_op['skills_needed']
    fill_in 'volunteer_op_contact_details', with: volunteer_op['contact']
    expect_any_instance_of(TwitterApi).to receive(:tweet).once
    click_on 'Create a Volunteer Opportunity'
  end
end

Given(/^I submit a volunteer op to Doit/) do |volunteer_ops_table|
  volunteer_ops_table.hashes.each do |volunteer_op|
    org = Organisation.find_by_name(volunteer_op['org_name'])
    visit organisation_path org
    click_link 'Create a Volunteer Opportunity'
    expect(current_path).to eq new_organisation_volunteer_op_path org
    fill_in 'Title', with: volunteer_op['title']
    fill_in 'Description', with: volunteer_op['desc']
    fill_in 'Address', with: volunteer_op['address']
    fill_in 'Postcode', with: volunteer_op['postcode']
    check('check_to_doit')
    select('Help Out Harrow!', from: 'Doit organisation')
    fill_in 'Advertise start date', with: Date.current.strftime("%F")
    fill_in 'Advertise end date', with: 10.days.from_now.strftime("%F")
    expect_any_instance_of(TwitterApi).to receive(:tweet).once
    click_on 'Create a Volunteer Opportunity'
  end
end

Given('I run the import doit service') do
  ImportDoItVolunteerOpportunities.with
end

Given(/^I run the import doit service with a radius of (\d+\.?\d*) miles$/) do |radius|
  ImportDoItVolunteerOpportunities.with radius.to_f
end

Given(/^I run the import reachskills service$/) do
  ImportReachSkillsVolunteerOpportunities.with
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

Given(/^there is a posted vol op with doit id "(.*?)"$/) do |doit_id|
  DoitTrace.create(doit_volop_id: doit_id)
end

Then(/^the doit volunteer op with id "(.*?)" should not be stored$/) do |doit_id|
  expect(VolunteerOp.find_by(doit_op_id: doit_id)).to be nil
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
  click_on 'Update Volunteer Opportunity'
end

Given /^I update "(.*?)" volunteer op title to be "(.*?)"$/ do |title, description|
  vop = VolunteerOp.find_by_title title
  visit volunteer_op_path vop
  click_on 'Edit'
  fill_in('Title', :with => title)
  click_on 'Update Volunteer Opportunity'
end

Given /^I should see (\d+) markers in the map$/ do |num|
  expect(page).to have_css('.vol_op', count: num)
end

Then(/^I should see a link to "(.*?)" page "(.*?)"$/) do |link, url|
  page.should have_link(link, :href => url)
end

Then(/^I should see a tracking link to "(.*?)" page "(.*?)"$/) do |link, url|
  page.should have_link(link, :href => "#{url}")
end

When(/^I set new volunteer opportunity location to "(.*?)", "(.*?)"$/) do |addr, pc|
  fill_in 'Address', with: addr
  fill_in 'Postcode', with: pc
  click_button 'Update Volunteer Opportunity'
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
    first, _, _, fourth = all('.key_text').to_a

    expect(first).to have_link('Do-it', href: 'https://do-it.org/')
    expect(fourth).to have_link('Do-it', href: 'https://do-it.org/')
  end
end

Then(/^I should see a search form$/) do
  expect(page).to have_css('form.volunteer-ops-search')
end

Given /^wait for (\d+) seconds?$/ do |n|
	sleep(n.to_i)
end

Given(/^I fill additional fields required by Doit$/) do
  select("Help Out Harrow!", from: 'doit_volunteer_op_doit_org_id')
  fill_in('Advertise start date', with: '2017-03-01')
  fill_in('Advertise end date', with: '2017-04-01')

end
