class AddDeletedAtIndexToProposedOrganisationEdit < ActiveRecord::Migration[4.2]
  def change
    add_index :proposed_organisation_edits, :deleted_at
  end
end
