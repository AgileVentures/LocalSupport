require 'csv'

class Organization < ActiveRecord::Base
  acts_as_gmappable :check_process => false

  #This method is overridden to save organization if address was failed to geocode
  def run_validations!
    run_callbacks :validate
    remove_errors_with_address
    errors.empty?
  end

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

  #Title,Charity Number,Activities,Contact Name,Contact Address,website,Contact Telephone,date registered,date removed,accounts date,spending,income,company number,OpenlyLocalURL,twitter account name,facebook account name,youtube account name,feed url,Charity Classification,signed up for 1010,last checked,created at,updated at,Removed?

  @@NAME_COLUMN = 0
  @@DESCRIPTION_COLUMN = 2
  @@ADDRESS_COLUMN = 4
  @@WEBSITE_COLUMN = 5
  @@TELEPHONE_COLUMN = 6
  @@DATE_REMOVED_COLUMN = 8

  def self.create_from_array(array)
    return nil if array[@@DATE_REMOVED_COLUMN]

    address = self.parse_address(array[@@ADDRESS_COLUMN])

    self.create :name => array[@@NAME_COLUMN].to_s.humanized_all_first_capitals,
                :description => self.humanize_description(array[@@DESCRIPTION_COLUMN]),
                :address => address[:address].humanized_all_first_capitals,
                :postcode => address[:postcode],
                :website => array[@@WEBSITE_COLUMN],
                :telephone => array[@@TELEPHONE_COLUMN]
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

  private

  def remove_errors_with_address
    errors_hash = errors.to_hash
    errors.clear
    errors_hash.each do |key, value|
      if key.to_s != 'gmaps4rails_address'
        errors.add(key, value)
      else
        # nullify coordinates
        self.latitude = nil
        self.longitude = nil
      end
    end
  end
end

class String
  def humanized_all_first_capitals
    self.humanize.split(' ').map{|w| w.capitalize}.join(' ')
  end
end
