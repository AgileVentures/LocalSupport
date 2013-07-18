require 'csv'

class Organization < ActiveRecord::Base
  acts_as_gmappable :check_process => false
  has_many :users
  has_and_belongs_to_many :categories
  # Setup accessible (or protected) attributes for your model
  # prevents mass assignment on other fields not in this list
  attr_accessible :name, :description, :address, :postcode, :email, :website, :telephone, :donation_info

  #This method is overridden to save organization if address was failed to geocode
  def run_validations!
    run_callbacks :validate
    remove_errors_with_address
    errors.empty?
  end

  def self.search_by_keyword(keyword)
    self.where("UPPER(description) LIKE ? OR UPPER(name) LIKE ?","%#{keyword.try(:upcase)}%","%#{keyword.try(:upcase)}%")
  end

  def self.filter_by_category(category_id)
    return scoped unless category_id.present?
    # could use this but doesn't play well with search by keyqord since table names are remapped
    #Organization.includes(:categories).where("categories_organizations.category_id" =>  category_id)
    category = Category.find_by_id(category_id)
    orgs = category.organizations.each {|org| org.id} if category
    where(:id => orgs)
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

  #Edit this if CSV 'schema' changes
  #value is the name of a column in csv file
  @@column_mappings = {
      name: 'Title',
      address: 'Contact Address',
      description: 'Activities',
      website: 'website',
      telephone: 'Contact Telephone',
      date_removed: 'date removed',
      cc_id: 'Charity Classification'
  }

  def self.import_categories_from_array(row)
    check_columns_in(row)
   # return nil if row[@@column_mappings[:date_removed]]
    org = Organization.find_by_name(row[@@column_mappings[:name]].to_s.humanized_all_first_capitals)
    if org
      #sort out the categories
      row[@@column_mappings[:cc_id]].split(',').each do |id|
        cat = Category.find_by_charity_commission_id(id.to_i)
        org.categories << cat
      end
    end
    org
  end
  def self.import_category_mappings(filename, limit)
    csv_text = File.open(filename, 'r:ISO-8859-1')
    count = 0
    CSV.parse(csv_text, :headers => true).each do |row|
      if count >= limit
        break
      end
      count += 1
      begin
        self.import_categories_from_array(row)
      rescue CSV::MalformedCSVError => e
        logger.error(e.message)
      end
    end
  end
  def self.create_from_array(row, validate)
    check_columns_in(row)
    return nil if row[@@column_mappings[:date_removed]]
    address = self.parse_address(row[@@column_mappings[:address]])

    org = Organization.new
    org.name = row[@@column_mappings[:name]].to_s.humanized_all_first_capitals
    #POSSIBLE APPPROACH BELOW ... OR COULD PUT ALL NEW STUFF IN SEPARATE METHOD CALLED UPDATE_CATEGORIES
    # grab all classifications
    if Organization.find_by_name(org.name)
      # check for classifications and add as necessary
      # add them to existing organization
      return nil
    end
    # add them to new organization

    org.description = self.humanize_description(row[@@column_mappings[:description]])
    org.address = address[:address].humanized_all_first_capitals
    org.postcode = address[:postcode]
    org.website = row[@@column_mappings[:website]]
    org.telephone = row[@@column_mappings[:telephone]]

    # this commented throttling code might work well for db:seed, but
    # relies of hard validation failures, which we must avoid
    # in the normal operation of the app
    #begin
      org.save! validate: validate
    #rescue ActiveRecord::RecordInvalid => e
      #if e.message =~ /Gmaps4rails address Address invalid/
        #begin
          #Gmaps4rails.geocode(org.gmaps4rails_address)
        #rescue Gmaps4rails::GeocodeStatus => e
          #if e.message =~ /OVER_QUERY_LIMIT/
            ## throttle the rate of saves
            #sleep(2000)
            #org.save! validate: validate
          #end
        #end
      #end
    #end

    org
  end

  def self.import_addresses(filename, limit, validation = true)
    csv_text = File.open(filename, 'r:ISO-8859-1')
    count = 0
    CSV.parse(csv_text, :headers => true).each do |row|
      if count >= limit
        break
      end
      count += 1
      begin
        self.create_from_array(row, validation)
      rescue CSV::MalformedCSVError => e
        logger.error(e.message)
      end
    end
  end

  def self.check_columns_in(row)
    @@column_mappings.each_value do |column_name|
      unless row.header?(column_name)
        raise CSV::MalformedCSVError, "No expected column with name #{column_name} in CSV file"
      end
    end
  end

  private

  def remove_errors_with_address
    errors_hash = errors.to_hash
    errors.clear
    errors_hash.each do |key, value|
      logger.warn "#{key} --> #{value}"
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
