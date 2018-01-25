class RenameCategoriesOrganizationsFKorganizationId < ActiveRecord::Migration[4.2]
  def change
    rename_column :categories_organisations, :organization_id, :organisation_id
  end
end
