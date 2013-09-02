require 'csv'

class Organization < ActiveRecord::Base
  acts_as_gmappable :check_process => false
  has_many :users
  has_and_belongs_to_many :categories
  # Setup accessible (or protected) attributes for your model
  # prevents mass assignment on other fields not in this list
  attr_accessible :name, :description, :address, :postcode, :email, :website, :telephone, :donation_info
  accepts_nested_attributes_for :users

  #This method is overridden to save organization if address was failed to geocode
  def run_validations!
    run_callbacks :validate
    remove_errors_with_address
    errors.empty?
  end
  #TODO: Give this TLC and refactor the flow or refactor out responsibilities
  def update_attributes_with_admin(params)
    email = params[:admin_email_to_add]
    result = false
    if !email.blank?
       result = ActiveRecord::Base.transaction do
         usr = User.find_by_email(email)
         if usr == nil
           self.errors.add(:administrator_email, "The user email you entered,'#{email}', does not exist in the system")
           raise ActiveRecord::Rollback
         else
           self.users << usr
           self.update_attributes(params)
         end
       end
    else
      result = self.update_attributes(params)
    end
    return result
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

  def self.humanize_description(unfriendly_description) 
    unfriendly_description && unfriendly_description.humanize
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
    organization_name = row[@@column_mappings[:name]].to_s.humanized_all_first_capitals
    
    return nil if row[@@column_mappings[:date_removed]]      # don't create org if deleted
    return nil if Organization.find_by_name(organization_name)     # don't create existing org

    #return nil if Organization.removed_from_register?(row)
    #return nil if Organization.already_exists?(organization_name)

    org = build_organization_from_array(row, organization_name)

    org.save! validate: validate
    org
  end

  def self.build_organization_from_array(row, organization_name)
    org = Organization.new
    address = Address.parse_address(row[@@column_mappings[:address]])
    org.name = organization_name
    org.description = self.humanize_description(row[@@column_mappings[:description]])
    org.address = address[:address].humanized_all_first_capitals
    org.postcode = address[:postcode]
    org.website = row[@@column_mappings[:website]]
    org.telephone = row[@@column_mappings[:telephone]]
    return org
  end
  private_class_method :build_organization_from_array

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
