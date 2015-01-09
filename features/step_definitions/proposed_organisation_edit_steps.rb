Then(/^the telephone field of the proposed edit should be pre\-populated with the telephone of the organisation named "(.*?)"$/) do |name|
  org_phone = Organisation.find_by_name(name).telephone
  expect(page).to have_field('proposed_organisation_edit_telephone', with: org_phone)
end

Then(/^the address of the organisation named "(.*?)" should not be editable nor appear$/) do |name|
  org_address = Organisation.find_by_name(name).address
  expect(page).not_to have_content org_address
  expect(page).not_to have_field('proposed_organisation_edit_address')
end