class AddAcceptedAndArchivedToProposedOrganisationEdit < ActiveRecord::Migration[4.2]
  def change
      change_table :proposed_organisation_edits do |t|
        t.boolean :accepted, default: false, null: false
        t.boolean :archived, default: false, null: false
      end
  end
end
