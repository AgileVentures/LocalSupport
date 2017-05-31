class VolunteerOp < ActiveRecord::Base
  acts_as_paranoid
  validates :title, :description, presence: true
  validates :organisation_id, presence: true, if: "source == 'local'"
  belongs_to :organisation

  geocoded_by :full_address
  after_validation :geocode, if: :address_complete?
  after_validation :clear_lat_lng, if: "source == 'local'"

  scope :order_by_most_recent, -> { order('updated_at DESC') }
  scope :local_only,           -> { where(source: 'local') }
  scope :doit,                 -> { where(source: 'doit') }
  scope :reachskills,          -> { where(source: 'reachskills') }
  scope :remote_only,          -> { where.not(source: 'local') }
  
  def self.add_coordinates(vol_ops)
    vol_op_with_coordinates(vol_ops)
  end
  
  def full_address
    "#{self.address}, #{self.postcode}"
  end

  def organisation_name
    return organisation.name if source == 'local'
    return doit_org_name if source == 'doit'
    reachskills_org_name
  end

  def organisation_link
    return organisation if source == 'local'
    return "https://do-it.org/organisations/#{doit_org_link}" if source == 'doit'
    "https://reachskills.org.uk/org/#{parsed_reachskills_org_name}"
  end

  def link
    return self if source == 'local'
    return "https://do-it.org/opportunities/#{doit_op_id}" if source == 'doit'
    reachskills_op_link
  end

  def self.search_for_text(text)
    keyword = "%#{text}%"
    where(contains_description?(keyword).or(contains_title?(keyword)))
  end

  def self.contains_description?(text)
    arel_table[:description].matches(text)
  end

  def self.contains_title?(text)
    arel_table[:title].matches(text)
  end

  def self.build_by_coordinates
    local_vol_ops = vol_op_with_coordinates(VolunteerOp.local_only)
    vol_ops = local_vol_ops + VolunteerOp.remote_only
    vol_op_by_coordinates = group_by_coordinates(vol_ops)
    Location.build_hash(vol_op_by_coordinates)
  end

  def address_complete?
    address.present? && postcode.present?
  end

  def self.get_source(volunteer_ops)
    source = volunteer_ops.first.source
    unless volunteer_ops.all? { |vol_op| vol_op.source == source }
      source = 'mixed'
    end
    source
  end

  private
  
  def clear_lat_lng
    return if address_complete?
    self.longitude = nil
    self.latitude = nil
  end

  def self.vol_op_with_coordinates(vol_ops)
    vol_ops.map { |op| op.source == 'local' ? op.send(:lat_lng_supplier) : op }
  end

  def lat_lng_supplier
    return self if latitude && longitude
    send(:with_organisation_coordinates)
  end

  def with_organisation_coordinates
    self.tap do |v|
      v.longitude = v.organisation.longitude
      v.latitude = v.organisation.latitude
    end
  end

  def self.group_by_coordinates(vol_ops)
    vol_ops.group_by do |vol_op|
      [vol_op.longitude, vol_op.latitude]
    end
  end

  def parsed_reachskills_org_name
    reachskills_org_name.downcase.gsub(' ', '-')
  end

end
