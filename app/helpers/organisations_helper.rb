module OrganisationsHelper
  
  def render_link_categories(type, org, &block)
    org.categories.send(:"#{type}").map(&block)
  end
  
  def params_hash(type, category)
    hash = { what_id: '', who_id: '', how_id: '', q: '' }
    hash[:"#{type.split(/_/).first}_id"] = category.id
    hash
  end

  def link_to_organization(obj)
    url = organisation_path(obj)
    url += "?iframe=#{iframe}" if iframe
    url
  end
end