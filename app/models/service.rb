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
  geocoded_by :full_address

  def full_address
    "#{self.address}, #{self.postcode}"
  end

  def self.search_for_text(text)
    where('description LIKE ? OR name LIKE ?',
          "%#{text}%", "%#{text}%")
  end

  def self.from_model(model)
    Service.create(imported_at: model.imported_at, name: model.name,
                   description: model.description, telephone: model.telephone,
                   email: model.email, website: model.website,
                   address: model.address, postcode: model.postcode,
                   latitude: model.latitude, longitude: model.longitude)
  end

  def self.build_by_coordinates(services = nil)
    services = service_with_coordinates(services)
    Location.build_hash(group_by_coordinates(services))
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
