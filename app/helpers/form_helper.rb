module FormHelper
  def setup_organisation(organisation)
    (Category.all - organisation.categories).each do |category|
      organisation.category_organisations.build(:category => category)
    end
    organisation
  end
  def setup_proposed_organisation_edit(proposed_organisation_edit)
    proposed_organisation_edit.name = proposed_organisation_edit.organisation.name
    proposed_organisation_edit.description = proposed_organisation_edit.organisation.description
    proposed_organisation_edit.address = proposed_organisation_edit.organisation.address
    proposed_organisation_edit.postcode = proposed_organisation_edit.organisation.postcode
    proposed_organisation_edit.email = proposed_organisation_edit.organisation.email
    proposed_organisation_edit.website = proposed_organisation_edit.organisation.website
    proposed_organisation_edit.donation_info = proposed_organisation_edit.organisation.donation_info
    proposed_organisation_edit.telephone = proposed_organisation_edit.organisation.telephone
    proposed_organisation_edit.donation_info = proposed_organisation_edit.organisation.donation_info
    proposed_organisation_edit
  end
end
