Given(/^I click on the pending proposed edits link$/) do
  click_link "Pending Proposed Edits"
end

Then(/^I should not see the pending proposed edits link$/) do
  page.should_not have_link href: proposed_organisation_edits_path
end

Given(/^I click on view details for the proposed edit for the organisation named "(.*?)"$/) do |org_name|
  edit = ProposedOrganisationEdit.find_by(archived: false, organisation: Organisation.find_by(name: org_name))
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

Given(/^I visit the most recently created proposed edit for "(.*?)"$/) do |name|
  org = Organisation.find_by(name: name)
  edit = org.edits.reorder(created_at: :desc).first
  visit organisation_proposed_organisation_edit_path org, edit
end

Then(/^the most recently updated proposed edit for "(.*?)" should be updated as follows:$/) do |name, table|
  edit = Organisation.find_by(name: name).edits.reorder(updated_at: :desc).first
  require 'boolean'
  table.hashes.first.each do |attr, value|
    expect(edit.send(attr)).to eq Boolean.from(value)
  end
end

Then(/^the organisation named "(.*?)" should have fields as follows:$/) do |name, table|
 org = Organisation.find_by(name: name)
 table.hashes.first.each do |attr, value|
   expect(org.send(attr)).to eq value
 end
end

Then(/^I should see a view details link for each of the proposed organisations$/) do
  ProposedOrganisation.all.each do |proposed_org|
    expect(page).to have_link "View Details", href: proposed_organisation_path(proposed_org)
  end
end
