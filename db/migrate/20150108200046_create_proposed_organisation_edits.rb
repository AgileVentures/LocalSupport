class CreateProposedOrganisationEdits < ActiveRecord::Migration
  def change
    create_table :proposed_organisation_edits do |t|
      t.references :organisation
      t.string   "name"
      t.string   "address"
      t.string   "postcode"
      t.string   "email"
      t.text     "description"
      t.string   "website"
      t.string   "telephone"
      t.text     "donation_info"
      t.datetime "deleted_at"
    end
  end

  def down
    drop_table :proposed_organisation_edits
  end
end
