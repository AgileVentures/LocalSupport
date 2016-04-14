module FormHelper
  # def setup_organisation(organisation, cat_selected=nil)
  #   (Category.all - organisation.categories).each do |category|
  #     organisation.category_organisations.build(category: category) unless 
  #     in_selected_categories?(cat_selected, category.id)
  #   end
  #   organisation
  # end
  def setup_proposed_organisation_edit(proposed_organisation_edit)
    %w{name description address postcode email website donation_info telephone}.each do |field|
      proposed_organisation_edit.send("#{field}=".to_sym,proposed_organisation_edit.organisation.send(field.to_sym))
    end
    proposed_organisation_edit
  end
  # def in_selected_categories?(categories_selected, category_id)
  #   categories_selected && categories_selected.include?(category_id)
  # end
  def is_checked?(category_organisation, categories_selected)
    categories_selected.nil? || categories_selected.empty? ? 
    category_organisation.persisted? : categories_selected.any? {|v| v == category_organisation.category.id}
  end
    
end
