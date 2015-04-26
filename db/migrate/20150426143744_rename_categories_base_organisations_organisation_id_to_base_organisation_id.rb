class RenameCategoriesBaseOrganisationsOrganisationIdToBaseOrganisationId < ActiveRecord::Migration
  def change
    rename_column :categories_base_organisations, :organisation_id, :base_organisation_id
  end
end
