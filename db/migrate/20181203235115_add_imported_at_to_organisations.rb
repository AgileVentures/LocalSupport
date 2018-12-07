class AddImportedAtToOrganisations < ActiveRecord::Migration[5.1]
  def change
    add_column :organisations, :imported_at, :datetime
  end
end
