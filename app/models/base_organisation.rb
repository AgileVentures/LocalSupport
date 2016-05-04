class BaseOrganisation < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  
  acts_as_paranoid
  validates_url :website, prefferred_scheme: 'http://', message: 'Website is not a valid URL',
    if: proc{|org| org.website.present?}
  validates_url :donation_info, prefferred_scheme: 'http://', message: 'Donation url is not a valid URL',
    if: proc{|org| org.donation_info.present?}
  validates :name, presence: { message: "Name can't be blank"}
  validates :description, presence: { message: "Description can't be blank"}
  has_many :category_organisations, :foreign_key => :organisation_id
  has_many :categories, :through => :category_organisations, :foreign_key => :organisation_id
  accepts_nested_attributes_for :category_organisations,
                                :allow_destroy => true
  # For the geocoder gem
  geocoded_by :full_address
  after_validation :geocode, if: -> { run_geocode? }
  self.table_name = "organisations"

  def run_geocode?
    ## http://api.rubyonrails.org/classes/ActiveModel/Dirty.html
    address_changed? or postcode_changed? or (address.present? and not_geocoded?)
  end

  def not_geocoded?
    latitude.blank? and longitude.blank?
  end

  def full_address
     "#{self.address}, #{self.postcode}"
  end

  def gmaps4rails_marker_attrs
    if recently_updated_and_has_owner
      ['https://mt.googleapis.com/vt/icon/name=icons/spotlight/spotlight-poi.png',
        'data-id' => id,
       class: 'marker']
    else
      ['https://maps.gstatic.com/intl/en_ALL/mapfiles/markers2/measle.png',
        'data-id' => id,
        class: 'measle']
    end
  end

  def has_been_updated_recently?
    updated_at >= 1.year.ago
  end
  
  def setup_categories
    Category.all.each do |cat|
      self.category_organisations.build(category: cat) unless has_relation?(cat)
    end
    self
  end
    
  def has_relation?(category)
    self.category_organisations.any? {|v| v.category_id == category.id}
  end
  
  def slug_candidates
    # It checks if self.name is nil, because otherwise it breaks -
    # this happens during the name validation spec
    SlugSetup.setup(self.name) unless self.name.nil?
  end

end
