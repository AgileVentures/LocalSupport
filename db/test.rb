require 'csv'

csv_text = File.open('Harrow Charities.csv', 'r:ISO-8859-1')
csv = CSV.read(csv_text, :headers => true)

puts csv
