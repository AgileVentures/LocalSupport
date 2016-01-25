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

Feature.find(name: :volunteer_ops_create).activate
Feature.find(name: :volunteer_ops_list).activate
Feature.find(name: :automated_propose_org).activate
Feature.find(name: :search_input_bar_on_org_pages).activate