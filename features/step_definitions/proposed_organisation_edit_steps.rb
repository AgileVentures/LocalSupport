Then(/^the telephone field of the proposed edit should be pre\-populated with the telephone of the organisation named "(.*?)"$/) do |name|
  org_phone = Organisation.find_by_name(name).telephone
  expect(page).to have_field('proposed_organisation_edit_telephone', with: org_phone)
end

Then(/^the address of the organisation named "(.*?)" should not be editable nor appear$/) do |name|
  org_address = Organisation.find_by_name(name).address
  expect(page).not_to have_content org_address
  expect(page).not_to have_field('proposed_organisation_edit_address')
end
When(/^I propose the following edit:$/) do |table|

  table.hashes.each do |hash|
    fields = { name: 'proposed_organisation_edit_name',
               description: 'proposed_organisation_edit_description',
               website: 'proposed_organisation_edit_website', 
               email: 'proposed_organisation_edit_email'}
    hash.each_pair do |field_name, field_value|
      fill_in(fields[field_name.to_sym],:with => field_value)
    end
  end
end
  #
Then(/^"(.*?)" should have the following proposed edits:$/) do |name, table|
  proposed_edit = Organisation.find_by(name: name).edits.first
  table.hashes.each do |hash|
    hash.each_pair do |field_name, field_value|
      expect(proposed_edit.send(field_name)).to eq field_value
    end
  end
end
Then(/^the following proposed edits should be displayed on the page:$/) do |table|
  table.hashes.each do |hash|
    expect(page).to have_css('.current_value', :text => hash['current value'])
    expect(page).to have_css('.proposed_value', :text => hash['proposed value'])
  end
end
