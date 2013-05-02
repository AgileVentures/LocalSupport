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

  def self.humanize_description(unfriendly_description) 
    unfriendly_description && unfriendly_description.humanize
  end

  def self.parse_address(address_with_trailing_postcode)  
    address = address_with_trailing_postcode.to_s
    postcode = ''
    match = address_with_trailing_postcode.to_s.match(/(.*)(,\s*(\w\w\d\s* \d\w\w))/)
    if match
      if match.length == 4 
        address = match[1]
        postcode = match[3].to_s
      end
    end
    {:address => address, :postcode => postcode}
  end

  def self.create_from_array(array)
    address = self.parse_address(array[2])

    self.create :name => array[0].to_s.humanized_all_first_capitals,
		:description => self.humanize_description(array[1]),
		:address => address[:address].humanized_all_first_capitals,
                :postcode => address[:postcode],
		:website => array[3],
		:telephone => array[4]
  end

  def self.import_addresses(filename,limit)
    csv_text = File.open(filename, 'r:ISO-8859-1')
    count = 0
    CSV.parse(csv_text, :headers => true).each do |row|
		  if count >= limit
	            break
		  end
		  count += 1
		  self.create_from_array(row)
    end
  end
end

class String
  def humanized_all_first_capitals
    self.to_s.humanize.split(' ').map{|w| w.capitalize}.join(' ')
  end
end
