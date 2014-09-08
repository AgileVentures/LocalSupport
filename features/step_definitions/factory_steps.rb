def stub_request_with_address(address, body = nil)
  filename = "#{address.gsub(/\s/, '_')}.json"
  filename = File.read "test/fixtures/#{filename}"
  stub_request(:any, /maps\.googleapis\.com/).
      to_return(status => 200, :body => body || filename, :headers => {})
end

Given /^the following organisations exist:$/ do |organisations_table|
  organisations_table.hashes.each do |org|
    stub_request_with_address(org['address'])
    Organisation.create! org
  end
end

Given /^the following users are registered:$/ do |users_table|
  users_table.hashes.each do |user|
    user["admin"] = user["admin"] == "true"
    user["organisation"] = Organisation.find_by_name(user["organisation"])
    user["pending_organisation"] = Organisation.find_by_name(user["pending_organisation"])
    User.create! user, :without_protection => true
  end
end

Given /the following volunteer opportunities exist/ do |volunteer_ops_table|
  volunteer_ops_table.hashes.each do |volunteer_op|
    volunteer_op["organisation"] = Organisation.find_by_name(volunteer_op["organisation"])
    VolunteerOp.create! volunteer_op, :without_protection => true
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


Then(/^the organisation "([^"]*)" should be deleted$/) do |name|
  org = Organisation.only_deleted.find_by_name name
  expect(org).not_to be_nil
end