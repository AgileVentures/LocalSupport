# == Schema Information
#
# Table name: settings
#
#  id         :bigint           not null, primary key
#  key        :string
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Setting < ApplicationRecord
  
  DEFAULTS = {
    latitude: '51.5978',
    longitude: '-0.3370',
    site_provider: 'Voluntary Action Harrow Cooperative',
    site_provider_url: 'http://www.voluntaryactionharrow.org.uk/',
    site_title: 'Harrow Community Network',
    site_brand: 'Search for local voluntary and community organisations',
    site_locale: 'Harrow',
    site_key_asset_type: 'volunteer opportunities',
    site_stakeholders: 'local residents and organisations',
    meta_tag_title: 'Harrow Community Network',
    meta_tag_site: 'Harrow volunteering',
    meta_tag_description: 'Volunteering Network for Harrow Community',
    open_graph_site: 'Harrow Community Network',
    large_banner_path: 'HCN-long.png',
    small_banner_path: 'HCN-small.png', 
    site_provider_small_logo: 'VAHC-Small-Logo.png',
    map_zoom_level: '12',
    embedded_map_zoom_level: '14',
    map_legend_script: 'map_legend_script',
    feedback_form_url: 'https://docs.google.com/a/neurogrid.com/forms/d/1iQwIM0E2gjJF6N6UHgVwtH8OzBbpUr6DS0Xbf-UrKE0/viewform'
  }

  def self.method_missing(args)
    find_by(key: args.to_s).try(:value) || DEFAULTS[args]
  end
end
