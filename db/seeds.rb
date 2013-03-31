# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

csv_text = File.open('db/data.csv', 'r:ISO-8859-1')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  row = row.to_hash.with_indifferent_access
  Organization.create!(row.to_hash.symbolize_keys)
end
