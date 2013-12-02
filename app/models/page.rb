class Page < ActiveRecord::Base
  attr_accessible :content, :name, :permalink
  validates_presence_of :name, :permalink
  validates_uniqueness_of :permalink

  # Override method to allow static pages to be found via permalink instead of id
  def to_param
    permalink
  end

  def self.find_page id
    Page.find_by_permalink(id) || Page.find_by_name!('Custom 404')
  end
end
