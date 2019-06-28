# == Schema Information
#
# Table name: organisations
#
#  id                    :integer          not null, primary key
#  address               :string(255)      default(""), not null
#  deleted_at            :datetime
#  description           :text             default(""), not null
#  donation_info         :text             default(""), not null
#  email                 :string(255)      default(""), not null
#  gmaps                 :boolean
#  imported_at           :datetime
#  imported_from         :string
#  latitude              :float
#  longitude             :float
#  name                  :string(255)      default(""), not null
#  non_profit            :boolean
#  postcode              :string(255)      default(""), not null
#  publish_address       :boolean          default(FALSE)
#  publish_email         :boolean          default(TRUE)
#  publish_phone         :boolean          default(FALSE)
#  slug                  :string
#  telephone             :string(255)      default(""), not null
#  type                  :string           default("Organisation")
#  website               :string(255)      default(""), not null
#  created_at            :datetime
#  updated_at            :datetime
#  charity_commission_id :integer
#  imported_id           :integer
#
# Indexes
#
#  index_organisations_on_slug  (slug) UNIQUE
#

class BaseOrganisation < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  
  acts_as_paranoid
  validates_url :website, preferred_scheme: 'http://', message: 'Website is not a valid URL',
    if: proc{|org| org.website.present?}
  validates_url :donation_info, preferred_scheme: 'http://', message: 'Donation url is not a valid URL',
    if: proc{|org| org.donation_info.present?}
  validates :name, presence: { message: "Name can't be blank"}
  has_many :category_organisations, foreign_key: :organisation_id
  has_many :categories, through: :category_organisations, foreign_key: :organisation_id

  # For the geocoder gem
  geocoded_by :full_address

  self.table_name = 'organisations'

  def check_geocode
    geocode if run_geocode?
  end

  def run_geocode?
    # trigger geocode if I have an address but no coordinates and
    # the object is being created
    return (!address.empty? and not_geocoded?) if id.nil?
    # if address or postcode has changed, trigger the geocode
    # address must be present
    (address_changed? or postcode_changed?) or (address.present? and not_geocoded?)
  end

  def not_geocoded?
    latitude.blank? and longitude.blank?
  end

  def full_address
    return self.address if self.postcode.blank?
    return self.postcode if self.address.blank?
     "#{self.address}, #{self.postcode}"
  end

  def gmaps4rails_marker_attrs
    if has_been_updated_recently?
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
