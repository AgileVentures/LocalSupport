class Location

  attr_reader :longitude, :latitude

  def initialize(longitude:, latitude:)
    @longitude = longitude
    @latitude = latitude
  end
  
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
end
