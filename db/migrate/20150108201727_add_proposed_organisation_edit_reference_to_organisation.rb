class AddProposedOrganisationEditReferenceToOrganisation < ActiveRecord::Migration
  def up
    change_table :organisations do |t|
      t.references :proposed_organisation_edit
    end
  end

  def down
    remove_column :organisations, :proposed_organisation_edit_id
  end
end
