class BaseOrganisation < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  
  acts_as_paranoid
  validates_url :website, preferred_scheme: 'http://', message: 'Website is not a valid URL',
    if: proc{|org| org.website.present?}
  validates_url :donation_info, preferred_scheme: 'http://', message: 'Donation url is not a valid URL',
    if: proc{|org| org.donation_info.present?}
  validates :name, presence: { message: "Name can't be blank"}
  validates :description, presence: { message: "Description can't be blank"}
  has_many :category_organisations, :foreign_key => :organisation_id
  has_many :categories, :through => :category_organisations, :foreign_key => :organisation_id
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
      ['marker.png',
        'data-id' => id,
       class: 'marker']
    else
      ['measle.png',
        'data-id' => id,
        class: 'measle']
    end
  end

  def has_been_updated_recently?
    updated_at >= 1.year.ago
  end
  
  def slug_candidates
    SetupSlug.run(self.name) 
  end

end
