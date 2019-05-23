class AddImportFieldsToOrganisations < ActiveRecord::Migration[5.2]
  def change
    add_column :organisations, :imported_from, :string
    add_column :organisations, :imported_id, :integer
    add_column :organisations, :charity_commission_id, :integer
  end
end
