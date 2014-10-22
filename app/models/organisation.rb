require 'csv'

class String
  def humanized_all_first_capitals
    self.humanize.split(' ').map{|w| w.capitalize}.join(' ')
  end
end

class Organisation < ActiveRecord::Base
  #validates_presence_of :website, :with => /http:\/\//
  acts_as_paranoid
  validates_url :website, :prefferred_scheme => 'http://', :if => Proc.new{|org| org.website.present?}
  validates_url :donation_info, :prefferred_scheme => 'http://', :if => Proc.new{|org| org.donation_info.present?}

  # http://stackoverflow.com/questions/10738537/lazy-geocoding
  acts_as_gmappable :check_process => false, :process_geocoding => :run_geocode?
  has_many :users
  has_many :volunteer_ops
  has_many :category_organisations
  has_many :categories, :through => :category_organisations
  # Setup accessible (or protected) attributes for your model
  # prevents mass assignment on other fields not in this list
  attr_accessible :name, :description, :address, :postcode, :email, :website, :telephone, :donation_info, :publish_address, :publish_phone, :publish_email, :category_organisations_attributes
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :category_organisations,
                                :allow_destroy => true
  scope :order_by_most_recent, order('updated_at DESC')
  scope :not_null_email, :conditions => "organisations.email <> ''"
  # Should we not use :includes, which pulls in extra data? http://nlingutla.com/blog/2013/04/21/includes-vs-joins-in-rails/
  # Alternative => :joins('LEFT OUTER JOIN users ON users.organisation_id = organisations.id)
  # Difference between inner and outer joins: http://stackoverflow.com/a/38578/2197402
  scope :null_users, lambda { includes(:users).where("users.organisation_id IS NULL") }
  scope :without_matching_user_emails, :conditions => "organisations.email NOT IN (#{User.select('email').to_sql})"

  after_save :uninvite_users, if: ->{ email_changed? }

  def uninvite_users
    users.invited_not_accepted.update_all(organisation_id: nil)
  end

  def run_geocode?
    ## http://api.rubyonrails.org/classes/ActiveModel/Dirty.html
    address_changed? or (address.present? and not_geocoded?)
  end

  def not_geocoded?
    latitude.blank? and longitude.blank?
  end

  #This method is overridden to save organisation if address was failed to geocode
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
     keyword = "%#{keyword}%"
     self.where(contains_description(keyword).or(contains_name(keyword)))
  end

  def self.filter_by_category(category_id)
    return scoped unless category_id.present?
    self.joins(:categories).where(is_in_category(category_id)) #do we need to sanitize category_id?
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
    org = Organisation.find_by_name(org_name)
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
    CreateOrganisationFromArray.create(Organisation, row, validate)
  end

  def self.create_and_validate(attributes) 
    create!(attributes)
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
    str = ''
    import(filename, limit, validation) do |row, validation|
      str << add_email(row, validation)
    end
    str
  end

  def self.add_email(row, validation)
    orgs = where("UPPER(name) LIKE ? ","%#{row[0].try(:upcase)}%")
    return "#{row[0]} was not found\n" unless orgs && orgs[0] && orgs[0].email.blank?
    orgs[0].email = row[7]
    orgs[0].save
    return "#{row[0]} was found\n"
  end

  def self.check_columns_in(row)
    @@column_mappings.each_value do |column_name|
      unless row.header?(column_name)
        raise CSV::MalformedCSVError, "No expected column with name #{column_name} in CSV file"
      end
    end
  end

  def generate_potential_user
    password = Devise.friendly_token.first(8)
    user = User.new(:email => self.email, :password => password)
    unless user.valid?
      user.save
      return user # so that it can be inspected for errors
    end
    user.skip_confirmation_notification!
    user.reset_password_token=(User.reset_password_token)
    user.reset_password_sent_at=Time.now
    user.save!
    user.confirm!
    user
  end

  private

  def self.table
    self.arel_table
  end

  def self.category_table
    Category.arel_table
  end

  def self.is_in_category(category_id)
    category_table[:id].eq(category_id)
  end
  
  def self.contains_description(key)
    table[:description].matches(key)
  end

  def self.contains_name(key)
    table[:name].matches(key)
  end
  
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
