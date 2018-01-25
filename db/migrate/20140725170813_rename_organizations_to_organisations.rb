class RenameOrganizationsToOrganisations < ActiveRecord::Migration[4.2]
  def change
    rename_table :organizations, :organisations
  end
end
