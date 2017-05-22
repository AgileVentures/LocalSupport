class AddDeletedAtIndexToProposedOrganisationEdit < ActiveRecord::Migration
  def change
    add_index :proposed_organisation_edits, :deleted_at
  end
end
