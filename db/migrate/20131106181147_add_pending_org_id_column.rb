class AddPendingOrgIdColumn < ActiveRecord::Migration
  def up
    add_column :users, :pending_organization_id, :integer
  end

  def down
    remove_column :users, :pending_organization_id
  end
end
