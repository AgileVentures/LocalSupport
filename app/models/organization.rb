class Organization < ActiveRecord::Base
  acts_as_gmappable :check_process => false

  def self.search_by_keyword(keyword)
    self.where("description LIKE ?","%#{keyword}%")
  end
  
  def gmaps4rails_address
    "#{self.address}, #{self.postcode}"
  end

  def gmaps4rails_infowindow
    "#{self.name}"
  end

  # def self.create_from_text_file(filename, limit)
    #csv_text = File.open(filename, 'r:ISO-8859-1')
    #count = 0
    #CSV.parse(csv_text, :headers => true).each do |row|
		  #if count > limit
			  #break
		  #end
		  #count += 1
		  #self.create_from_text(row)
		#end

#.take
  # end

  def self.extract_postcode(address_with_trailing_postcode)
    match = address_with_trailing_postcode.match(/\s*(\w\w\d\s* \d\w\w)/)
    match && match[1]
  end

  def self.create_from_text(csv_string)
    #debugger
    parsed = CSV.parse(csv_string)

    description = parsed[0][1]
    description = description.humanize if description
    name = parsed[0][0] 
    name = name.humanized_all_first_capitals if name
    address = parsed[0][2].sub(/,\s*\w\w\d\s* \d\w\w/,"")
    address = address.humanized_all_first_capitals if address

    #tokens = string.split(',')
    self.create :name => name,
		:description => description,
		:address => address,
    :postcode => self.extract_postcode parsed[0][2],
		:website => parsed[0][3],
		:telephone => parsed[0][4]

  end

  #def self.import_build_addresses(filename)

  #end
end

class String
  def humanized_all_first_capitals
    self.humanize.split(' ').map{|w| w.capitalize}.join(' ')
  end
end
