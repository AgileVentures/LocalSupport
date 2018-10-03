class Event < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :organisation_id, presence: true, on: [:create]
  validate :start_date_cannot_be_greater_than_end_date
  belongs_to :organisation

  scope :upcoming, lambda { |n|
    where('start_date >= ?', Time.zone.now.to_date)
      .order('start_date ASC')
      .limit(n)
  }
  scope :search, lambda { |query|
    keyword = "%#{query}%"
    where(contains_description?(keyword).or(contains_title?(keyword))).upcoming(10)
  }
enum occur: { never: 0, daily: 1, weekly: 2, biweekly: 3, monthly: 4 }

  # For the geocoder gem
  geocoded_by :address

  def all_day_event?
    self.start_date == self.start_date.midnight && self.end_date == self.end_date.midnight
  end

  def self.build_by_coordinates(events = nil)
    events = event_with_coordinates(events)
    Location.build_hash(group_by_coordinates(events))
  end

  def schedule
    schedule = IceCube::Schedule.new(now= start_date)
    case occur
    when 'daily'
      schedule.add_recurrence_rule IceCube::Rule.daily(1)
    when 'weekly'
      schedule.add_recurrence_rule IceCube::Rule.weekly(1)
    when 'biweekly'
      schedule.add_recurrence_rule IceCube::Rule.weekly(2)
    when 'monthly'
      schedule.add_recurrence_rule IceCube::Rule.monthly(1)
    end
    schedule
  end

  def recurring_events
    schedule.occurrences_between(start_date, 10.days.from_now).map do |date|
      Event.new(id: id, title: title, description: description,
                organisation_id: organisation_id, address: address,
                start_date: date, end_date: date+ (end_date - start_date))
    end

  end
  private

  def self.event_with_coordinates(events)
    events.map do |ev|
      ev.send((ev.address.present?) ? :lat_lng_supplier : :lat_lng_default )
    end
  end

  def lat_lng_default
    return send(:with_organisation_coordinates) unless organisation.nil?
    self.tap do |e|
      e.longitude = 0.0
      e.latitude = 0.0
    end
  end

  def lat_lng_supplier
    return self if (latitude && longitude) and !address_changed?
    check_geocode
  end
  
  def check_geocode
    coordinates = geocode
    return send(:lat_lng_default) unless coordinates
    self.tap do |e|
      e.latitude = coordinates[0]
      e.longitude = coordinates[1]
    end
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

  def start_date_cannot_be_greater_than_end_date
    errors.add(:start_date, 'Start date must come after End date') unless
    start_date && end_date && start_date < end_date
  end

end
