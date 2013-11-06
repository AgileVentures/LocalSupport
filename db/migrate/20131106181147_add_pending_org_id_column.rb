class AddPendingOrgIdColumn < ActiveRecord::Migration
  def up
    add_column :organizations, :pending_organization_id, :integer
  end

  def down
    remove_column :organizations, :pending_organization_id
  end
end
