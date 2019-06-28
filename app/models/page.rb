# == Schema Information
#
# Table name: pages
#
#  id           :integer          not null, primary key
#  content      :text
#  link_visible :boolean          default(TRUE)
#  name         :string(255)
#  permalink    :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pages_on_permalink  (permalink)
#

class Page < ApplicationRecord
  #attr_accessible :content, :name, :permalink, :link_visible
  validates :name, presence: true
  validates :permalink, presence: true, uniqueness: true

  # Provides links for page footers
  def self.visible_links
    pages = Page.where(link_visible: true)
    pages.map do |page|
      {name: page.name, permalink: page.permalink}
    end
  end

  # Override method to allow static pages to be found via permalink instead of id
  def to_param
    permalink
  end
end
