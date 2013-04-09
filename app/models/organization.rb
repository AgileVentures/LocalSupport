class Organization < ActiveRecord::Base
  acts_as_gmappable :check_process => false

  def self.search_by_keyword(keyword)
    self.where("description LIKE ?","%#{keyword}%")
  end
  
  def gmaps4rails_address
    "#{self.address}, #{self.postcode}"
  end

  def gmaps4rails_infowindow
    "#{self.name}"
  end
end
