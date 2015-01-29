module FormHelper
  def setup_organisation(organisation)
    (Category.all - organisation.categories).each do |category|
      organisation.category_organisations.build(:category => category)
    end
    organisation
  end
  def setup_proposed_organisation_edit(proposed_organisation_edit)
    %w{name description address postcode email website donation_info telephone}.each do |field|
      proposed_organisation_edit.send("#{field}=".to_sym,proposed_organisation_edit.organisation.send(field.to_sym))
    end
    proposed_organisation_edit
  end
end
