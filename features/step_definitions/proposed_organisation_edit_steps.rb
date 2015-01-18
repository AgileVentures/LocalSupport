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
               email: 'proposed_organisation_edit_email',
               postcode: 'proposed_organisation_edit_postcode',
               telephone: 'proposed_organisation_edit_telephone',
               donation_info: 'proposed_organisation_edit_donation_info',
               address: 'proposed_organisation_edit_address'}
    hash.each_pair do |field_name, field_value|
      fill_in(fields[field_name.to_sym],:with => field_value)
    end
  end
end
  #
Then(/^"(.*?)" should have the following proposed edits by user "(.*?)":$/) do |name, editor_email, table|
  proposed_edit = Organisation.find_by(name: name).edits.first
  editor = User.find_by(email: editor_email)
  expect(proposed_edit.editor).to eq editor
  table.hashes.each do |hash|
    hash.each_pair do |field_name, field_value|
      expect(proposed_edit.send(field_name)).to eq field_value
    end
  end
end

Then(/^the following proposed edits should be displayed on the page:$/) do |table|
  table.hashes.each do |hash|
    current_class = '.current_organisation_' + hash['field']
    proposed_class = '.proposed_organisation_' + hash['field']
    expect(page).to have_css("#{current_class}.current_value")
    expect(page).to have_css("#{proposed_class}.proposed_value")
    if (hash['field'] == 'website')
      if hash['current value'].blank?
        expect(page).not_to have_css(current_class + " .field_value a")
      else
        expect(page).to have_css current_class + " .field_value a"
      end
      if hash['proposed value'].blank?
        expect(page).not_to have_css(proposed_class + " .field_value a")
      else
        expect(page).to have_css proposed_class + " .field_value a"
      end
    end
    if hash['field'] == 'description'
      expect(find(current_class).text).to eq hash['current value']
      expect(find(proposed_class).text).to eq hash['proposed value']
    else
      within(current_class) do
        expect(find('.field_value').text).to eq hash['current value']
      end
      within(proposed_class) do
        expect(find('.field_value').text).to eq hash['proposed value']
      end
    end

  end
end

Given(/^the following proposed edits exist:$/) do |table|
  table.hashes.each do |hash|
    create_hash = {}
    hash.each_pair do |field_name, field_value|
      key_value_to_add = {field_name.to_sym => field_value}
      key_value_to_add = {editor: User.find_by(email: field_value)} if field_name == "editor_email"
      key_value_to_add = {organisation: Organisation.find_by(name: field_value)} if field_name == "original_name"
      create_hash.merge! key_value_to_add
    end
    ProposedOrganisationEdit.create! create_hash
  end
end
