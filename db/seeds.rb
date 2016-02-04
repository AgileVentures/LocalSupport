# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Organisation.import_addresses 'db/data.csv', 1006
user = User.where(email: "superadmin@harrowcn.org.uk").first_or_initialize
user.password = "asdf1234"
user.password_confirmation = "asdf1234"
user.confirmed_at = DateTime.now
user.superadmin = true
user.save!

user = User.where(email: "admin@harrowcn.org.uk").first_or_initialize
user.password = "asdf1234"
user.password_confirmation = "asdf1234"
user.confirmed_at = DateTime.now
user.superadmin = true
user.save!

user = User.where(email: "siteadmin@harrowcn.org.uk").first_or_initialize
user.password = "asdf1234"
user.password_confirmation = "asdf1234"
user.confirmed_at = DateTime.now
user.siteadmin = true
user.save!

3.times do |n|
  VolunteerOp.create(description: "This is a test#{n}", title: "Test#{n}", organisation_id: "#{1 + n}")
end

Feature.activate('volunteer_ops_create')
Feature.activate('volunteer_ops_list')
Feature.activate('automated_propose_org')
Feature.activate('search_input_bar_on_org_pages')

