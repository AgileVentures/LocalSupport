module FormHelper
  def setup_proposed_organisation_edit(proposed_organisation_edit)
    %w{name description address postcode email website donation_info telephone}.each do |field|
      proposed_organisation_edit.send("#{field}=".to_sym,proposed_organisation_edit.organisation.send(field.to_sym))
    end
    proposed_organisation_edit
  end
  
  def persisted_or_checked?(cat_org, cat_selected)
    cat_selected.blank? ? cat_org.persisted? : checked?(cat_selected,cat_org) 
  end
  
  def checked?(cat_selected, cat_org)
    cat_selected.any? {|v| v == cat_org.category.id}
  end
  
end
