class RenameCategoryOrganisationsToCategoryBaseOrganisations < ActiveRecord::Migration
  def change
    rename_table :categories_organisations, :categories_base_organisations
  end
end
