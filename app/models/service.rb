# == Schema Information
#
# Table name: services
#
#  id              :bigint           not null, primary key
#  activity_type   :string
#  address         :string
#  beneficiaries   :string
#  description     :text
#  email           :string
#  imported_at     :datetime
#  imported_from   :string
#  latitude        :float
#  longitude       :float
#  name            :string
#  postcode        :string
#  telephone       :string
#  website         :string
#  where_we_work   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  contact_id      :string
#  organisation_id :integer
#

class Service < ApplicationRecord
  scope :order_by_most_recent, -> { order('created_at DESC') }
  belongs_to :organisation
  has_many :self_care_category_services
  has_many :self_care_categories, through: :self_care_category_services
  geocoded_by :full_address

  alias_attribute :title, :name
  def source
    'local'
  end

  delegate :name, to: :organisation, prefix: true

  def organisation_link
    organisation
  end

  def self.where_we_work_values
    ['Queen\'s Park & Paddington', 'Kensington & Chelsea', 'Westminster', 'Hammersmith & Fulham']
  end

  def self.activity_values
    ['Group', 'One to One']
  end

  def full_address
    "#{self.address}, #{self.postcode}"
  end

  def self.search_for_text(text)
    where('description LIKE ? OR name LIKE ?',
          "%#{text}%", "%#{text}%")
  end

  def self.search_by_category(text)
    where('description LIKE ? OR name LIKE ?',
          "%#{text}%", "%#{text}%")
  end

  def self.from_model(model, contact = nil)
    Service.find_or_initialize_by(contact_id: id(contact)) do |service|
      save_service_attributes service, model, contact
    end
  end

  def self.id(contact)
    Integer(contact['organisation']['Contact ID'])
  end

  def self.build_by_coordinates(services = nil)
    services = service_with_coordinates(services)
    Location.build_hash(group_by_coordinates(services))
  end
  
  def self.filter_by_categories(category_ids)
    joins(:self_care_categories)
      .where(SelfCareCategory.arel_table[:id].in category_ids) # at this point, services in multiple categories show up as duplicates
      .group(arel_table[:id])                            # so we exploit this
      .having(arel_table[:id].count.eq category_ids.size) # and return the services with correct number of duplicates
  end

  def self.save_service_attributes(service, model, contact)
    service.imported_at = model.imported_at
    service.name = model.name
    service.description = model.description
    service.telephone = model.telephone
    service.email = model.email 
    service.website = model.website
    service.address = model.address
    service.postcode = model.postcode
    service.latitude = model.latitude
    service.longitude = model.longitude
    service.organisation = model
    service.where_we_work = contact['organisation']['Where we work'] if contact
    service.activity_type = contact['organisation']['Self Care One to One or Group'] if contact
    service.associate_categories(contact)
  end

  def associate_categories(contact)
    return self unless contact     
    first_category = contact['organisation']['Self care service category']          
    second_category = contact['organisation']['Self Care Category Secondary']          
    self_care_categories << SelfCareCategory.find_or_create_by(name: first_category) unless first_category.blank?
    self_care_categories << SelfCareCategory.find_or_create_by(name: second_category) unless second_category.blank?
    save!
  end

  private
  
  def self.service_with_coordinates(services)
    services.map do |service|
      # binding.pry
      service.send((service.address.present?) ? :lat_lng_supplier : :lat_lng_default )
    end
  end
  
  def lat_lng_default
    return send(:with_organisation_coordinates) unless organisation.nil?
    self.tap do |service|
      service.longitude = 0.0
      service.latitude = 0.0
    end
  end
  
  def lat_lng_supplier
    return self if (latitude && longitude) and !address_changed?
    check_geocode
  end
  
  def check_geocode
    coordinates = geocode
    return send(:lat_lng_default) unless coordinates
    self.tap do |service|
      service.latitude = coordinates[0]
      service.longitude = coordinates[1]
    end
  end

  def with_organisation_coordinates
    self.tap do |service|
      service.longitude = service.organisation.longitude
      service.latitude = service.organisation.latitude
    end
  end

  def self.group_by_coordinates(services)
    services.group_by do |service|
      [service.longitude, service.latitude]
    end
  end
end
