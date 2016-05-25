module OrganisationsHelper
  
  def render_link_categories(type, org, &block)
    org.categories.send(:"#{type}").map(&block)
  end
  
  def params_hash(type, category)
    hash = { what_id: '', who_id: '', how_id: '', q: '' }
    hash[:"#{type.split(/_/).first}_id"] = category.id
    hash
  end

end