class Page < ActiveRecord::Base
  attr_accessible :content, :name, :permalink, :link_visible
  validates_presence_of :name, :permalink
  validates_uniqueness_of :permalink

  # Provides links for page footers
  def self.visible_links
  end

  # Override method to allow static pages to be found via permalink instead of id
  def to_param
    permalink
  end
end
