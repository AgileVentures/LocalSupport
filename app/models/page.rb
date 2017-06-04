class Page < ActiveRecord::Base
  #attr_accessible :content, :name, :permalink, :link_visible
  validates :name, presence: true
  validates :permalink, presence: true
  validates_uniqueness_of :permalink

  # Provides links for page footers
  def self.visible_links
    pages = Page.where(link_visible: true)
    pages.map do |page|
      {:name => page.name, :permalink => page.permalink}
    end
  end

  # Override method to allow static pages to be found via permalink instead of id
  def to_param
    permalink
  end
end
