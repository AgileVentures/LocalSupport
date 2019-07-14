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
    service = Service.create(imported_at: model.imported_at, name: model.name,
                   description: model.description, telephone: model.telephone,
                   email: model.email, website: model.website,
                   address: model.address, postcode: model.postcode,
                   latitude: model.latitude, longitude: model.longitude,
                   organisation: model)
    associate_categories(service, contact)
    service
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

  private

  def self.associate_categories(service, contact)
    return service unless contact     
    first_category = contact['organisation']['Self care service category']          
    second_category = contact['organisation']['Self Care Category Secondary']          
    service.self_care_categories << SelfCareCategory.find_or_create_by(name: first_category) unless first_category.blank?
    service.self_care_categories << SelfCareCategory.find_or_create_by(name: second_category) unless second_category.blank?
    service.save!
  end
  
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
