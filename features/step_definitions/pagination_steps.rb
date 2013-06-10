require 'webmock/cucumber'
require 'uri-handler'

Given /^I have created (\d+) organizations$/ do |number|
  Organization.import_addresses 'db/data.csv', number.to_i
end

Then /^I should(| again) see a list of (\d+) organizations on the (index page|search page with query .+)$/ do |number, str, page|
  number = number.to_i
  orgs = nil
  if page == "index page"
    orgs = Organization.order("updated_at DESC")
  else
    /search page with query (.+)/.match(page)
    orgs = Organization.search_by_keyword($1)
  end
  number.times do |n|
    check_contact_details orgs[n].name
  end
end

When /^I scroll down the organizations list$/ do
  page.execute_script("$('#orgs_scroll')[0].scrollTop = 100")
end