class UserRenameAdminToSuperadmin < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :admin, :superadmin
  end
end
