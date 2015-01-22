And /^I select the "(.*?)" category$/ do |category|
  select(category, :from => "category[id]")
end

When(/^I visit "(.*?)"$/) do |path|
  visit path
end

def paths(location)
  {
      'home' => root_path,
      'sign up' => new_user_registration_path,
      'sign in' => new_user_session_path,
      'organisations index' => organisations_path,
      'new organisation' => new_organisation_path,
      'contributors' => contributors_path,
      'password reset' => edit_user_password_path,
      'invitation' => accept_user_invitation_path,
      'organisations without users' => organisations_report_path,
      'all users' => users_report_path,
      'invited users' => invited_users_report_path,
      'volunteer opportunities' => volunteer_ops_path,
      'new organisation' => new_organisation_path,
      'contributors' => contributors_path,
      'deleted users' => deleted_users_report_path
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
                    id: record.id
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
  # http://stackoverflow.com/a/15782921
  # Capybara "visible?" method(s) are inaccurate!

  #regex = /height: 0/ # Assume style="height: 0px;" is the only means of invisibility
  #style = page.find("##{id}")['style']
  #sleep 0.25 if style # need to give js a moment to modify the DOM
  #expectation = negate ? :should : :should_not
  #style ? style.send(expectation, have_text(regex)) : negate.nil?

  elem = page.find("##{id}")
  negate ? !elem.visible? : elem.visible?
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
