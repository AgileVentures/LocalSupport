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

And /^I select the "(.*?)" category$/ do |category|
  select(category, :from => "category[id]")
end
