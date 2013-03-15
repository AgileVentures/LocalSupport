class Organization < ActiveRecord::Base
  acts_as_gmappable
  
  def gmaps4rails_address
    "#{self.address}, #{self.postcode}"
  end
end
