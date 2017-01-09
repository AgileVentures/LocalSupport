Then (/^I should( not)? see an "Accept Proposed Organisation" button$/) do |negation|
  if negation
    expect(page).not_to have_button "Accept"
  else
      expect(page).to have_button "Accept"
  end
end

And(/^having accepted the proposed organisation named "(.*?)", I see "(.*?)"$/) do |org_name, message|
  visit_proposed_organisation name: org_name
  press_acceptance_for_proposed_organisation
  assert_on_organisation_show_page name: org_name
  expect(page).to have_content message
end

Given(/^I accept the proposed_organisation named "(.*?)"$/) do |org_name|
  visit_proposed_organisation name: org_name
  press_acceptance_for_proposed_organisation
  assert_on_organisation_show_page name: org_name
end

Then (/^I should( not)? see a "Reject Proposed Organisation" button$/) do |negation|
  if negation
    expect(page).not_to have_button "Reject"
  else
    expect(page).to have_button "Reject"
  end
end

Then(/^I click on the pending proposed organisations link$/) do
  click_link "Pending Proposed Organisations"
end

Then (/^I should not see an add organisation link$/) do
  expect(page).to_not have_link("Add Organisation", new_proposed_organisation_path)
end

Then(/^I should be on the show page for the organisation that was proposed$/) do
  steps %{Then I should be on the show page for the organisation named "#{unsaved_proposed_organisation.name}"}
end

Then(/^the proposed organisation should have been rejected$/) do
  expect(ProposedOrganisation.find_by(name: unsaved_proposed_organisation.name)).to be_nil
  expect(Organisation.find_by(name: unsaved_proposed_organisation.name)).to be_nil
end
