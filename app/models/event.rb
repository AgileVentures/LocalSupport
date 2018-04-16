class Event < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :organisation_id, presence: true, on: [:create]
  belongs_to :organisation

  scope :upcoming, lambda { |n|
    where('start_date >= ?', Time.zone.now.to_date)
      .order('start_date ASC')
      .limit(n)
  }
  scope :search, lambda { |query|
    keyword = "%#{query}%"
    where(contains_description?(keyword).or(contains_title?(keyword))).limit(10)
  }
  
  # For the geocoder gem
  geocoded_by :address

  def all_day_event?
    self.start_date == self.start_date.midnight && self.end_date == self.end_date.midnight
  end

  def self.build_by_coordinates(events = nil)
    events = event_with_coordinates(events)
    Location.build_hash(group_by_coordinates(events))
  end

  private

  def self.event_with_coordinates(events)
    events.map do |ev|
      ev.send(ev.organisation.nil? ? :lat_lng_default : :lat_lng_supplier)
    end
  end

  def lat_lng_default
    self.tap do |e|
      e.longitude = 0.0
      e.latitude = 0.0
    end
  end

  def lat_lng_supplier
    return self if latitude && longitude
    return check_geocode unless address.nil? or address.empty?
    send(:with_organisation_coordinates)
  end
  
  def check_geocode
    if run_geocode?
      coordinates = geocode
      self.tap do |e|
        e.latitude = coordinates[0]
        e.longitude = coordinates[1]
      end
    end
  end

  def run_geocode?
    return (!address.empty? and not_geocoded?) if id.nil?
    (address_changed?) or (address.present? and not_geocoded?)
  end

  def not_geocoded?
    latitude.blank? and longitude.blank?
  end

  def with_organisation_coordinates
    self.tap do |e|
      e.longitude = e.organisation.longitude
      e.latitude = e.organisation.latitude
    end
  end

  def self.group_by_coordinates(events)
    events.group_by do |event|
      [event.longitude, event.latitude]
    end
  end

  def self.table
    arel_table
  end

  def self.contains_description?(key)
    table[:description].matches(key)
  end

  def self.contains_title?(key)
    table[:title].matches(key)
  end
end
