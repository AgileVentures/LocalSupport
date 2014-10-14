class RenameCategoriesOrganizationsToCategoriesOrganisations < ActiveRecord::Migration
  def change
    rename_table :categories_organizations, :categories_organisations
  end
end
