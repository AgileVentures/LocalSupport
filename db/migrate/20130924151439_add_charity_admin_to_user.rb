class AddCharityAdminToUser < ActiveRecord::Migration
  def up
    add_column :users, :charity_admin, :boolean, :default => false, :null => false
    add_index  :users, :charity_admin
  end
  def down
    remove_index  :users, :charity_admin
    remove_column :users, :charity_admin
  end
end
