module FormHelper
  def setup_proposed_organisation_edit(proposed_organisation_edit)
    %w{name description address postcode email website donation_info telephone}.each do |field|
      proposed_organisation_edit.send("#{field}=".to_sym,proposed_organisation_edit.organisation.send(field.to_sym))
    end
    proposed_organisation_edit
  end
  def is_checked?(category_organisation, categories_selected)
    categories_selected.nil? || categories_selected.empty? ? 
    category_organisation.persisted? : categories_selected.any? {|v| v == category_organisation.category.id}
  end
    
end
