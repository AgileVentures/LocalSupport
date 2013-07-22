require 'webmock/cucumber'
require 'uri-handler'

Given /^I have created (\d+) organizations$/ do |number|
  number.to_i.times do |n|
    FactoryGirl.create(:organization, :name => "org#{n}", :description => "description#{n}")
  end
end

Then /^I should see a list of (\d+) organizations on the (index page|search page with query (.+))$/ do |number, page, query|
  orgs = nil
  if page == "index page"
    orgs = Organization.order("updated_at DESC")
  else
    orgs = Organization.search_by_keyword($1)
  end
  number.to_i.times do |n|
    check_contact_details orgs[n].name
  end
end

When /^I scroll down the organizations list$/ do
  page.execute_script("$('#orgs_scroll')[0].scrollTop = 100")
end