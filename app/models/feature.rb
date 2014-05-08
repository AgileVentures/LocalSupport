class Feature < ActiveRecord::Base
  attr_accessible :name, :active
  validates :name, presence: true, uniqueness:true, allow_blank: false

  def self.deactivate(feature)
    find_by_name(feature).update_attribute(:active, false)
  end

  def self.activate(feature)
    find_by_name(feature).update_attribute(:active, true)
  end

  def self.active?(feature)
    flag = find_by_name(feature)
    flag.nil? ? true : flag.active?
  end
end
