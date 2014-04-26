Given /^the following organizations exist:$/ do |organizations_table|
  organizations_table.hashes.each do |org|
    Organization.create! org
  end
end

Given /^the following users are registered:$/ do |users_table|
  users_table.hashes.each do |user|
    user["admin"] = user["admin"] == "true"
    user["organization"] = Organization.find_by_name(user["organization"])
    user["pending_organization"] = Organization.find_by_name(user["pending_organization"])
    User.create! user, :without_protection => true
  end
end

Given /the following volunteer opportunities exist/ do |volunteer_ops_table|
  volunteer_ops_table.hashes.each do |volunteer_op|
    volunteer_op["organization"] = Organization.find_by_name(volunteer_op["organization"])
    VolunteerOp.create! volunteer_op, :without_protection => true
  end
end

Given /the following categories exist/ do |categories_table|
  categories_table.hashes.each do |cat|
    Category.create! cat
  end
end

Given /^the following categories_organizations exist:$/ do |join_table|
  join_table.hashes.each do |row|
     cat = Category.find_by_name row[:category]
     org = Organization.find_by_name row[:organization]
     org.categories << cat
  end
end

Given /^the following pages exist:$/ do |pages_table|
  pages_table.hashes.each do |page|
    Page.create! page
  end
end

When(/^a static page named "(.*?)" with permalink "(.*?)" and markdown content:$/) do |name, permalink, content|
  Page.create!({:name => name, :permalink => permalink, :content => content})
end

And(/^a file exists:$/) do |table|
  CSV.open("db/email_test.csv", "wb") do |csv|
    csv << table.hashes[0].keys
    table.hashes.each do |org|
      csv << org.values
    end
  end
end
