require 'csv'
require 'string'

class Organisation < BaseOrganisation

  has_many :volunteer_ops
  has_many :users
  has_many :edits, class_name: 'ProposedOrganisationEdit', :dependent => :destroy

  accepts_nested_attributes_for :users # TODO check if needed

  scope :order_by_most_recent, -> { order('organisations.updated_at DESC') }
  scope :not_null_email, lambda {where("organisations.email <> ''")}

  # Should we not use :includes, which pulls in extra data? http://nlingutla.com/blog/2013/04/21/includes-vs-joins-in-rails/
  # Alternative => :joins('LEFT OUTER JOIN users ON users.organisation_id = organisations.id)
  # Difference between inner and outer joins: http://stackoverflow.com/a/38578/2197402

  scope :null_users, lambda { includes(:users).where("users.organisation_id IS NULL").references(:users) }
  scope :without_matching_user_emails, lambda {where("organisations.email NOT IN (#{User.select('email').to_sql})")}

  after_save :uninvite_users, if: ->{ email_changed? }

  def uninvite_users
    users.invited_not_accepted.update_all(organisation_id: nil)
  end

  def update_attributes_with_superadmin(params)
    email = extract_email_from(params)
    return unless email.blank? || can_add_or_invite_admin?(email)
    self.update_attributes(params)
  end

  def self.search_by_keyword(keyword)
     keyword = "%#{keyword}%"
     where(contains_description?(keyword).or(contains_name?(keyword)))
  end

  def self.filter_by_categories(category_ids)
    joins(:categories)
      .where(category_id.in category_ids)                 # at this point, orgs in multiple categories show up as duplicates
      .group(organisation_id)                             # so we exploit this
      .having(organisation_id.count.eq category_ids.size) # and return the orgs with correct number of duplicates
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
    # create!(attributes.select{|k,v| !v.nil?})
    create!(attributes.each { |k, v| attributes[k] =v.nil? ? 'No information recorded' : (v.empty? ? 'No information recorded' : v) })
  end

  def self.create_and_substitute_with_empty(attributes)
    create!(attributes.each { |k, v| attributes[k] = v.empty? ? 'NO INFORMATION RECORDED' : v })
  end

  def self.import_addresses(filename, limit, validation = true)
    import(filename, limit, validation) do |row, validation|
       sleep 0.1
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
    orgs[0].email = row[7].to_s
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

  private

  def embellish_invite_error_and_add_to_model(email, error_msg)
    error_msg = ("Error: Email is invalid" == error_msg) ? "The user email you entered,'#{email}', is invalid" : error_msg
    self.errors.add(:superadministrator_email, error_msg)
  end

  def add_and_notify(usr)
    self.users << usr
    org_admin_email = [usr.email]
    OrgAdminMailer.new_org_admin(self, org_admin_email).deliver_now
  end

  def can_add_or_invite_admin?(email)
    return false if email.blank?
    usr = User.find_by_email(email)
    return add_and_notify(usr) if usr.present?
    result = ::SingleInviteJob.new(self, email).invite_user
    return true if result.invited_user?
    embellish_invite_error_and_add_to_model(email,result.error)
    false
  end

  def extract_email_from(params)
    email = params[:superadmin_email_to_add]
    params.delete :superadmin_email_to_add
    email
  end

  def self.table
    arel_table
  end

  def self.organisation_id
    table[:id]
  end

  def self.category_table
    Category.arel_table
  end

  def self.category_id
    category_table[:id]
  end

  def self.contains_description?(key)
    table[:description].matches(key)
  end

  def self.contains_name?(key)
    table[:name].matches(key)
  end


end
