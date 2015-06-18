class OrganisationDefaultStringValues < ActiveRecord::Migration

  ATTRS = %i[
    name
    address
    postcode
    email
    description
    website
    telephone
    donation_info
  ]

  def up
    ATTRS.each do |attr|
      Organisation.table_name = "organisations"
      Organisation.with_deleted.where(attr => nil).update_all(attr => "")
      ProposedOrganisationEdit.with_deleted.where(attr => nil).update_all(attr => "")
      change_column_default(:organisations, attr, "")
      change_column_null(:organisations, attr, false)
      change_column_default(:proposed_organisation_edits, attr, "")
      change_column_null(:proposed_organisation_edits, attr, false)
    end
  end

  def down
    ATTRS.each do |attr|
      change_column_default(:organisations, attr, nil)
      change_column_null(:organisations, attr, true)
      change_column_default(:proposed_organisation_edits, attr, nil)
      change_column_null(:proposed_organisation_edits, attr, true)
      Organisation.table_name = "organisations"
      Organisation.with_deleted.where(attr => "").update_all(attr => nil)
      ProposedOrganisationEdit.with_deleted.where(attr => "").update_all(attr => nil)
    end
  end
end
