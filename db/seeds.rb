# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

num = 30

count = 0
#csv_text = File.open('db/data.csv', 'r:ISO-8859-1')
#csv = CSV.parse(csv_text, :headers => true)
File.open('db/data.csv', 'r:ISO-8859-1').each_line do |line|
#csv.each do |row|
  if count > num
    break
  end
  count += 1
  Organization.create_from_text(line)
end
#Organization.import_build_addresses 'db/data.csv'
