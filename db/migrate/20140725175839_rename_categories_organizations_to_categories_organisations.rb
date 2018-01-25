class RenameCategoriesOrganizationsToCategoriesOrganisations < ActiveRecord::Migration[4.2]
  def change
    rename_table :categories_organizations, :categories_organisations
  end
end
