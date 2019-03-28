class Setting < ApplicationRecord
  def self.latitude
    find_by(key: 'latitude').try(:value) || '51.5978'
  end
  def self.longitude
    find_by(key: 'longitude').try(:value) || '-0.3370'
  end
end
