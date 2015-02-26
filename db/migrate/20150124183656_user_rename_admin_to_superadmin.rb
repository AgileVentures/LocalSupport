class UserRenameAdminToSuperadmin < ActiveRecord::Migration
  def change
    rename_column :users, :admin, :superadmin
  end
end
