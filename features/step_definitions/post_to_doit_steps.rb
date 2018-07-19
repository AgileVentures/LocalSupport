Given /^I submit a volunteer op with an arbitrary date on the "(.*?)" page$/ do |org_name|
  org = Organisation.find_by_name(org_name)
  visit organisation_path org
  click_link "Create a Volunteer Opportunity"
  check 'volunteer_op[post_to_doit]', id: 'check_to_doit'
  fill_in 'volunteer_op[advertise_start_date]', with: 'now'
  fill_in 'volunteer_op[advertise_end_date]', with: 'never'
  click_on 'Create a Volunteer Opportunity'
end
