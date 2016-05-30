
And /^I select the "(.*?)" category from (How They Help|Who They Help|What They Do)$/ do |category, cat_type|
  cat_id = case cat_type
    when 'What They Do'
      'what_id'
    when 'How They Help'
      'how_id'
    when 'Who They Help'
      'who_id'
    else
      raise "Unsupported category type"
  end
  select(category, :from => cat_id)
end

When /^I visit the proposed organisation show page for the proposed organisation that was proposed$/ do
  proposed_org = ProposedOrganisation.find_by(name: unsaved_proposed_organisation(User.first).name)
  visit proposed_organisation_path(proposed_org)
end
When(/^I visit "(.*?)"$/) do |path|
  visit path
end

def paths(location)
  reset_pwd = "#{edit_user_password_path}?reset_password_token=#{@reset_password_token}"
  {
    'home' => root_path,
    'sign up' => new_user_registration_path,
    'sign in' => new_user_session_path,
    'organisations index' => organisations_path,
    'organisations search' => organisations_search_path,
    'proposed organisations index' => proposed_organisations_path,
    'new organisation' => new_organisation_path,
    'new proposed organisation' => new_proposed_organisation_path,
    'contributors' => contributors_path,
    'password reset' => edit_user_password_path,
    'invitation' => accept_user_invitation_path,
    'invite users to become admin of organisations' => organisations_report_path,
    'registered users' => users_report_path,
    'invited users' => invited_users_report_path,
    'volunteer opportunities' => volunteer_ops_path,
    'volunteer opportunities search' => search_volunteer_ops_path,
    'contributors' => contributors_path,
    'deleted users' => deleted_users_report_path,
    'reset password' => reset_pwd
  }[location]
end

Then /^I (visit|should be on) the (.*) page$/ do |mode, location|
  location.downcase!
  raise "No matching path found for #{location}" if paths(location).nil?
  case mode
    when 'visit' then visit paths(location)
    when 'should be on' then current_path.should eq paths(location)
    else raise "unknown mode '#{mode}'"
  end
end

def find_record_for(object, schema, name)
  # all types begin as strings
  real_object = object.classify.constantize
  schema = schema.chomp('d').to_sym
  real_object.where(schema => name).first
end

Then /^I should be on the new organisation proposed edit page for the organisation named "(.*?)"$/ do |name|
  org = Organisation.find_by_name(name)
  url = new_organisation_proposed_organisation_edit_path org
  current_path.should eq url
end

Then /^I should be on the show organisation proposed edit page for the organisation named "(.*?)"$/ do |name|
  org = Organisation.find_by_name(name)
  prop_ed = org.edits.first
  url = organisation_proposed_organisation_edit_path org, prop_ed
  current_path.should eq url
end

Then /^I (visit|should be on) the new volunteer op page for "(.*?)"$/ do |mode, name|
  org = Organisation.find_by_name(name)
  url = new_organisation_volunteer_op_path(org)
  case mode
    when 'visit' then visit url
    when 'should be on' then current_path.should eq url
    else raise "unknown mode '#{mode}'"
  end
end

Then /^I (visit|should be on) the (edit|show) page for the (.*?) (named|titled) "(.*?)"$/ do |mode, action, object, schema, name|
  record = find_record_for(object, schema, name)
  url = url_for({
                    only_path: true,
                    controller: object.pluralize.underscore,
                    action: action,
                    id: record
                })
  case mode
    when 'visit' then visit url
    when 'should be on' then current_path.should eq url
    else raise "unknown mode '#{mode}'"
  end
end

And(/^the page should be titled "(.*?)"$/) do |title|
  page.should have_title(title)
end

And (/^I should see a full width layout$/) do
  within('#content') do
    page.should have_css('#one_column.span12')
  end
end

And (/^I should see a two column layout$/) do
  within('#content') do
    page.should have_css('#column1.span6')
    page.should have_css('#column2.span6')
  end
end

Then(/^the response status should be 404$/) do
  page.status_code.should == 404
end

Given /^I press "(.*?)"$/ do |button|
  click_button(button)
end

When /^I click "(.*)"$/ do |link|
  click_link(link)
end

When /^I click id "(.*)"$/ do |id|
  find("##{id}").click
  wait_for_ajax
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^following Disclaimer link should display Disclaimer$/ do
  steps %Q{
When I follow "Disclaimer"
Then I should see "Disclaimer"
And I should see "Whilst Voluntary Action Harrow has made effort to ensure the information here is accurate and up to date we are reliant on the information provided by the different organisations. No guarantees for the accuracy of the information is made."
}
end

Then(/^the "([^"]*)" should be (not )?visible$/) do |id, negate|
  expect(page).to have_css("##{id}", visible: negate)
end

Then(/^the "([^"]*)" should be "([^"]*)"$/) do |id, css_class|
  page.should have_css("##{id}.#{css_class}")
end

When(/^I click link with id "([^"]*)"$/) do |id|
  page.find("##{id}").click
end

When(/^javascript is enabled$/) do
  Capybara.javascript_driver
end

And(/^I click tableheader "([^"]*)"$/) do |name|
  find('th', :text => "#{name}").click
  wait_for_ajax
end

Then(/^navbar button "(.*?)" should( not)? be active$/) do |button_text, negative|
  expectation_method = negative ? :should_not : :should
  within('.nav.nav-pills.pull-right') do
    page.send(expectation_method, have_css('li.active > a', :text => "#{button_text}"))
  end
end

Then(/^the page includes a hyperlink to "([^"]*)"$/) do |link|
  #page.should have_link link
  page.should have_xpath("//a[contains(.,'#{link}') and @href=\"#{link}\"]")
end

Then(/^the page includes email hyperlink "([^"]*)"$/) do  |link|
  page.should have_link link
end

Then(/^I should see "([^"]*)" in the flash error$/) do |message|
  page.should have_css('div#flash_error', :text => message)
end

Then(/^I should see "([^"]*)" in the flash$/) do |message|
  page.should have_css('div#flash_success', :text => message)
end

Then(/^I should( not)? see the call to update details for organisation "(.*)"/) do |negative, org_name|
    org = Organisation.find_by_name org_name
    expectation_method = negative ? :should_not : :should
    message = "You have not updated your details in over a year! Please click here to update now."
    page.send(expectation_method, have_css('div#flash_warning', :text => message))

    within(negative.nil? ? 'div#flash_warning' : 'body') do
      page.send(expectation_method, have_link("here", :href => edit_organisation_path(org)))
    end
end
Then(/^I should see an (active|inactive) home button in the header$/) do |active|
    active_class = (active == "active") ? ".active" : ""
    within('.nav.nav-pills.pull-right') do
      expect(page).to have_css("li#{active_class} > a[href='/']", :text => "Home")
    end
end
