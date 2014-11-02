class RenameCharityWorkerToUser < ActiveRecord::Migration
  def up
    rename_table :charity_workers, :users
  end
  def down
    rename_table :users, :charity_workers
  end
end
