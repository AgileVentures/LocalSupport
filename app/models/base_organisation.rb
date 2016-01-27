class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "Please enter a valid postcode") unless
          value =~ /\A([A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKS-UW])\s?[0-9][ABD-HJLNP-UW-Z]{2}|(GIR\ 0AA)|(SAN\ TA1)|(BFPO\ (C\/O\ )?[0-9]{1,4})|((ASCN|BBND|[BFS]IQQ|PCRN|STHL|TDCU|TKCA)\ 1ZZ))\z/i  
  end
end

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "Please enter a valid email") unless
          value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  end
end

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "Please enter a valid URL") unless
          value =~ /\A(?:http:\/\/|https:\/\/|)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
  end
end

class BaseOrganisation < ActiveRecord::Base
  include ActiveModel::Validations

  before_validation :add_url_protocol

  acts_as_paranoid

  validates :postcode, presence: true, postcode: true
  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 3 }
  validates :email, uniqueness: true, presence: true, email: true
  validates :website, :donation_info, allow_blank: true, url: true

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

  def add_url_protocol
    self.website = "http://#{self.website}" if needs_url_protocol? self.website
    self.donation_info = "http://#{self.donation_info}" if needs_url_protocol? self.donation_info
  end

  private
  def needs_url_protocol? url
    !valid_url_with_protocol?(url) && url.length > 0
  end

  def valid_url_with_protocol? url
    url[/\Ahttp:\/\//] || url[/\Ahttps:\/\//]
  end
end
