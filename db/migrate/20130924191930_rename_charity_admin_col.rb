class RenameCharityAdminCol < ActiveRecord::Migration
  def up
    rename_column :users, :charity_admin, :charity_admin_pending
  end

  def down
    rename_column :users, :charity_admin_pending, :charity_admin
  end
end
