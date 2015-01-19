Given(/^I click on the all proposed edits link$/) do
  click_link "All Proposed Edits"
end

Then(/^I should not see the all proposed edits link$/) do
  page.should_not have_link href: proposed_organisation_edits_path
end

Given(/^I click on view details for the proposed edit for the organisation named "(.*?)"$/) do |org_name|
  edit = ProposedOrganisationEdit.find_by(organisation: Organisation.find_by(name: org_name))
  click_link "View Details", href: organisation_proposed_organisation_edit_path(edit.organisation, edit)
end

Then(/^"(.*?)" should be updated as follows:$/) do |org, table|
  expect(Organisation.find_by(name: org)).to be_nil
  organisation = Organisation.find_by(name: table.hashes.first["name"])
  table.hashes.each do |hash|
    hash.each_pair do |field_name, field_value|
      expect(organisation.send(field_name)).to eq(field_value)
    end
  end
end

