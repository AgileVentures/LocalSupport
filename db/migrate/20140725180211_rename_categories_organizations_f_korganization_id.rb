class RenameCategoriesOrganizationsFKorganizationId < ActiveRecord::Migration
  def change
    rename_column :categories_organisations, :organization_id, :organisation_id
  end
end
