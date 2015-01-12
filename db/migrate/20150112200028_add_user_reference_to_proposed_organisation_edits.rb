class AddUserReferenceToProposedOrganisationEdits < ActiveRecord::Migration
  def change
    add_reference :proposed_organisation_edits, :user, index: true
  end
  def down
    remove_reference :proposed_organisation_edits, :user
  end
end
