class Location

  attr_reader :longitude, :latitude

  def initialize(longitude:, latitude:)
    @longitude = longitude || CENTRAL_HARROW_LONGITUDE
    @latitude  = latitude  || CENTRAL_HARROW_LATITUDE
  end

  CENTRAL_HARROW_LATITUDE = 51.58056
  CENTRAL_HARROW_LONGITUDE = -0.34199

  def ==(other)
    self.class == other.class &&
      self.longitude == other.longitude &&
      self.latitude == other.latitude
  end

  alias eql? ==


  def hash
    [longitude, latitude].hash
  end

  def self.build_hash(vol_op_by_coordinates)
    hash = {}
    vol_op_by_coordinates.each do |key,val|
      hash[Location.new(longitude: key.first, latitude: key.last)] = val
    end
    hash
  end

  def self.create coordinates
    unless coordinates.nil?
      longitude = coordinates.longitude.to_f
      latitude  = coordinates.latitude.to_f
    end
    self.new longitude: longitude, latitude: latitude
  end
end
