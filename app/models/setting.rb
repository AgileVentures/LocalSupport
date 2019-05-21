class Setting < ApplicationRecord
  
  DEFAULTS = {
    latitude: '51.5978',
    longitude: '-0.3370',
    site_title: 'Harrow Community Network',
    meta_tag_title: 'Harrow Community Network',
    meta_tag_site: 'Harrow volunteering',
    meta_tag_description: 'Volunteering Network for Harrow Community',
    open_graph_site: 'Harrow Community Network',
    large_banner_path: 'HCN-long.png',
    small_banner_path: 'HCN-small.png',
    map_zoom_level: '12'
  }

  def self.method_missing(args)
    find_by(key: args.to_s).try(:value) || DEFAULTS[args]
  end
end
