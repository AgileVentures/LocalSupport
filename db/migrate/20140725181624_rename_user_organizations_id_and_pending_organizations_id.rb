class RenameUserOrganizationsIdAndPendingOrganizationsId < ActiveRecord::Migration
  def change
    rename_column :users, :organization_id, :organisation_id
    rename_column :users, :pending_organization_id, :pending_organisation_id
  end
end
