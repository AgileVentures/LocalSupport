# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Organization.import_addresses 'db/data.csv', 1006

user = User.new({
    email: "admin@harrowcn.org.uk",
    password: "asdf1234",
    password_confirmation: "asdf1234",
  })

user.confirmed_at = DateTime.now
user.admin = true

user.save!