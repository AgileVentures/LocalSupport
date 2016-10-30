Given(/^the following proposed organisations exist:$/) do |table|
  table.hashes.each do |hash|
    create_hash = {}
    proposer = nil
    hash.each_pair do |field_name, field_value|
      if field_name != "proposer_email"
        key_value_to_add = {field_name.to_sym => field_value}
      else
        proposer = User.find_by(email: field_value)
      end
      create_hash.merge! key_value_to_add unless key_value_to_add.nil?
    end
    proposed_org = ProposedOrganisation.new create_hash
    proposed_org.users << proposer if proposer
    proposed_org.save!
  end
end

Given /^I accept a proposed organisation called "(.*?)" with email "(.*?)"$/ do |name, email|
  steps %{
    Given the following proposed organisations exist:
      | name    | description         | address        | postcode | telephone | website            | email    | donation_info        | non_profit |
      | #{name} | Mourning loved ones | 30 pinner road | HA5 4HZ  | 520800000 | http://#{name}.org | #{email} | www.pleasedonate.com | true       |
    When I accept the proposed_organisation named "#{name}"
  }
end

Then /^"(.*?)" is (notified|invited|ignored) as an organisation admin of "(.*?)"$/ do |email, action, name|
  case action
  when 'notified'
    steps %{
      Then an email should be sent to "#{email}" as notification of the acceptance of proposed organisation "#{name}"
      And "#{email}" is an organisation admin of "#{name}"
    }
  when 'invited'
    steps %{
      Then an invitational email should be sent to "#{email}" as notification of the acceptance of proposed organisation "#{name}"
      And "#{email}" is an organisation admin of "#{name}"
    }
  when 'ignored'
    steps %{
      Then "#{email}" is not an organisation admin of "#{name}"
    }
  else raise "unknown action '#{action}'"
  end
end

Given(/^a proposed organisation has been proposed by "(.*)"$/) do |user_email|
  usr = User.find_by(email: user_email)
  unsaved_proposed_organisation(usr).save!
end

Then(/^I should see the details of the proposed organisation$/) do
  [:name, :description, :email, :address, :postcode].each do |key|
    expect(page).to have_content unsaved_proposed_organisation[key]
  end
  ["Donate to Friendly Charity now!", 'We are a not for profit organisation registered or working in Harrow'].each do |value|
      expect(page).to have_content value
  end
end

Given /^the following organisations exist:$/ do |organisations_table|
  organisations_table.hashes.each do |org|
    VCR.use_cassette("#{org["name"]}-#{org["postcode"]}") do
      Organisation.create! org
    end
  end
end

Given /^the following users are registered:$/ do |users_table|
  users_table.hashes.each do |user|
    user["superadmin"] = user["superadmin"] == "true"
    user["organisation"] = Organisation.find_by_name(user["organisation"])
    user["pending_organisation"] = Organisation.find_by_name(user["pending_organisation"])
    User.create! user
  end
end

Given /the following volunteer opportunities exist/ do |volunteer_ops_table|
  volunteer_ops_table.hashes.each do |volunteer_op|
    volunteer_op["organisation"] = Organisation.find_by_name(volunteer_op["organisation"])
    VolunteerOp.create! volunteer_op
  end
end

Given /^the following doit volunteer opportunities exist:$/ do |volunteer_ops_table|
  volunteer_ops_table.hashes.each do |volunteer_op|
    volunteer_op['source'] = 'doit'
    VolunteerOp.create! volunteer_op
  end
end

Given /the following categories exist/ do |categories_table|
  categories_table.hashes.each do |cat|
    Category.create! cat
  end
end

Given /^the following categories_organisations exist:$/ do |join_table|
  join_table.hashes.each do |row|
     cat = Category.find_by_name row[:category]
     org = Organisation.find_by_name row[:organisation]
     org.categories << cat
  end
end

Given /^the proposed organisations have the categories:$/ do |join_table|
  join_table.hashes.each do |row|
     cat = Category.find_by_name row[:category]
     org = ProposedOrganisation.find_by_name row[:proposed_organisation]
     org.categories << cat
  end
end

Given /^the following pages exist:$/ do |pages_table|
  pages_table.hashes.each do |page|
    Page.create! page
  end
end

When(/^a static page named "(.*?)" with permalink "(.*?)" and markdown content:$/) \
do |name, permalink, content|
  Page.create!(:name => name,
               :permalink => permalink,
               :content => content,
               :link_visible => true)
end

And(/^a file exists:$/) do |table|
  CSV.open("db/email_test.csv", "wb") do |csv|
    csv << table.hashes[0].keys
    table.hashes.each do |org|
      csv << org.values
    end
  end
end

Given(/^the invitation instructions mail template exists$/) do
  MailTemplate.create!(name: 'Invitation instructions',
                       body: 'Nothing',
                       footnote: 'Nothing',
                       email: 'noemail@email.org')
end


Then(/^the organisation "([^"]*)" should be deleted$/) do |name|
  org = Organisation.only_deleted.find_by_name name
  expect(org).not_to be_nil
end

Then(/^the "(.*?) proposed edits for the organisation named "(.*?)" should only be soft deleted$/) do |number, name|
  number = number.to_i
  org = Organisation.with_deleted.find_by(name: name)
  expect(ProposedOrganisationEdit.where(organisation: org)).to be_empty
  expect(ProposedOrganisationEdit.with_deleted.where(organisation: org).size).to eq number
end
