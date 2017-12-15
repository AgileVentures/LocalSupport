class RenameVolunteerOpsOrganizationId < ActiveRecord::Migration[4.2]
  def change
    rename_column :volunteer_ops, :organization_id, :organisation_id
  end
end
