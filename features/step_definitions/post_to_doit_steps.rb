Given "I submit a volunteer op with an arbitrary string" do
  org = Organisation.find_by_name("Friendly")
  visit new_organisation_volunteer_op_path org
  check 'volunteer_op[post_to_doit]', id: 'check_to_doit'
  fill_in 'volunteer_op[advertise_start_date]', with: 'now'
  fill_in 'volunteer_op[advertise_end_date]', with: 'never'
  click_on 'Create a Volunteer Opportunity'
end

Given "I submit a volunteer op with a start date in the past" do
  org = Organisation.find_by_name("Friendly")
  visit new_organisation_volunteer_op_path org
  check 'volunteer_op[post_to_doit]', id: 'check_to_doit'
  fill_in 'volunteer_op[advertise_start_date]', with: '1999-12-31'
  fill_in 'volunteer_op[advertise_end_date]', with: 'never'
  click_on 'Create a Volunteer Opportunity'
end

Given "I submit a volunteer op with an end date before the start date" do
  org = Organisation.find_by_name("Friendly")
  visit new_organisation_volunteer_op_path org
  check 'volunteer_op[post_to_doit]', id: 'check_to_doit'
  fill_in 'volunteer_op[advertise_start_date]', with: '1999-12-31'
  fill_in 'volunteer_op[advertise_end_date]', with: '1999-01-01'
  click_on 'Create a Volunteer Opportunity'
end

Given "I submit a volunteer op with valid dates" do
  org = Organisation.find_by_name("Friendly")
  visit new_organisation_volunteer_op_path org
  check 'volunteer_op[post_to_doit]', id: 'check_to_doit'
  fill_in 'volunteer_op[advertise_start_date]', with: Date.current.strftime('%Y-%m-%d')
  fill_in 'volunteer_op[advertise_end_date]', with: Date.tomorrow.strftime('%Y-%m-%d')
  click_on 'Create a Volunteer Opportunity'
end

Then "I should not see {string} and {string}" do |text1, text2|
  expect(page).not_to have_content text1
  expect(page).not_to have_content text2
end
