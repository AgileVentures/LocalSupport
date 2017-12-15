class AddUserReferenceToProposedOrganisationEdits < ActiveRecord::Migration[4.2]
  def change
    add_reference :proposed_organisation_edits, :user, index: true
    add_timestamps :proposed_organisation_edits, null: true
  end
  def down
    remove_reference :proposed_organisation_edits, :user
    remove_timestamps :proposed_organisation_edits
  end
end
