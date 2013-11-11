require 'csv'

class String
  def humanized_all_first_capitals
    self.humanize.split(' ').map{|w| w.capitalize}.join(' ')
  end
end

class Organization < ActiveRecord::Base
  # http://stackoverflow.com/questions/10738537/lazy-geocoding
  acts_as_gmappable :check_process => false, :process_geocoding => :run_geocode?
  has_many :users
  has_and_belongs_to_many :categories
  # Setup accessible (or protected) attributes for your model
  # prevents mass assignment on other fields not in this list
  attr_accessible :name, :description, :address, :postcode, :email, :website, :telephone, :donation_info
  accepts_nested_attributes_for :users

  # if we removed check_process => false saving the model would not trigger a geocode
  #after_commit :process_geocoding

  def run_geocode?
    ## http://api.rubyonrails.org/classes/ActiveModel/Dirty.html
    address_changed? or (address.present? and not_geocoded?)
  end

  def not_geocoded?
    latitude.blank? and longitude.blank?
  end

  #This method is overridden to save organization if address was failed to geocode
  def run_validations!
    run_callbacks :validate
    remove_errors_with_address
    errors.empty?
  end

  #TODO: Give this TLC and refactor the flow or refactor out responsibilities
  # This method both adds new editors and/or updates attributes
  def update_attributes_with_admin(params)
    email = params[:admin_email_to_add]
    if email.blank?
      return self.update_attributes(params)   # explicitly call with return to return boolean instead of nil
    end
    #Transactions are protective blocks where SQL statements are only permanent if they can all succeed as one atomic action.
    ActiveRecord::Base.transaction do
      usr = User.find_by_email(email)
      if usr.present?
        self.users << usr
        return self.update_attributes(params)
      else
        self.errors.add(:administrator_email, "The user email you entered,'#{email}', does not exist in the system")
        raise ActiveRecord::Rollback    # is this necessary? Doesn't the transaction block rollback the change with `usr` if update_attributes fails?
      end
    end
  end

  def self.search_by_keyword(keyword)
    self.where("UPPER(description) LIKE ? OR UPPER(name) LIKE ?","%#{keyword.try(:upcase)}%","%#{keyword.try(:upcase)}%")
  end

  def self.filter_by_category(category_id)
    return scoped unless category_id.present?
    # could use this but doesn't play well with search by keyqord since table names are remapped
    #Organization.includes(:categories).where("categories_organizations.category_id" =>  category_id)
    category = Category.find_by_id(category_id)
    orgs = category.organizations.select {|org| org.id} if category
    where(:id => orgs)
  end

  def gmaps4rails_address
    "#{self.address}, #{self.postcode}"
  end

  def gmaps4rails_infowindow
    "#{self.name}"
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
  def self.column_mappings
    @@column_mappings
  end
  def self.import_categories_from_array(row)
    check_columns_in(row)
    org_name = row[@@column_mappings[:name]].to_s.humanized_all_first_capitals
    org = Organization.find_by_name(org_name)
    check_categories_for_import(row, org)
    org
  end

  def self.check_categories_for_import(row, org)
    category_ids = row[@@column_mappings[:cc_id]] if org
    category_ids.split(',').each do |id|
      cat = Category.find_by_charity_commission_id(id.to_i)
      org.categories << cat
    end if category_ids
  end

  def self.import_category_mappings(filename, limit)
    import(filename, limit, false) do |row, validation| 
      import_categories_from_array(row) 
    end
  end

  def self.create_from_array(row, validate)
    CreateOrganizationFromArray.new(row).call(validate)
  end

  def self.import_addresses(filename, limit, validation = true)
    import(filename, limit, validation) do |row, validation| 
       create_from_array(row, validation) 
    end
  end

  def self.import(filename, limit, validation, &block)
    csv_text = File.open(filename, 'r:ISO-8859-1')
    count = 0
    CSV.parse(csv_text, :headers => true).each do |row|
      break if count >= limit
      count += 1
      begin
        yield(row, validation)
      rescue CSV::MalformedCSVError => e
        logger.error(e.message)
      end
    end
  end

  def self.import_emails(filename, limit, validation = true)
    import(filename, limit, validation) do |row, validation|
      add_email(row, validation)
    end
  end

  def self.add_email(row, validation)
    orgs = where("UPPER(name) LIKE ? ","%#{row[0].try(:upcase)}%")
    if orgs && orgs[0] && orgs[0].email.blank?
      orgs[0].email = row[7]
      orgs[0].save
    else
      puts "#{row[0]} was not found"
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
