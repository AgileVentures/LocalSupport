class RenameVolunteerOpsOrganizationId < ActiveRecord::Migration
  def change
    rename_column :volunteer_ops, :organization_id, :organisation_id
  end
end
