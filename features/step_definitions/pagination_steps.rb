require 'webmock/cucumber'
require 'uri-handler'

Given /^I have created (\d+) organizations$/ do |number|
  number.to_i.times do |n|
    # TODO some way of stubbing geocode here (I think) to prevent hitting external service - I get
    # getaddrinfo: nodename nor servname provided, or not known (SocketError)
    # otherwise ...
    #Gmaps4rails.stub(:geocode => nil)
    stub_request_with_address("64 pinner road")
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
    check_search_results orgs[n].name
  end
end

When /^I scroll down the organizations list$/ do
  page.execute_script("$('#orgs_scroll')[0].scrollTop = 100")
end