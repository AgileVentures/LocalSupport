class RenameCharityWorkerToUser < ActiveRecord::Migration
  def up
    rename_table :charity_workers, :users
    #rename_index :users, :index_charity_workers_on_email, :index_users_on_email
    #rename_index :users, :index_charity_workers_on_reset_password_token, :index_users_on_reset_password_token
  end
  def down
    rename_table :users, :charity_workers
    #rename_index :charity_workers, :index_users_on_email, :index_charity_workers_on_email
    #rename_index :charity_workers, :index_users_on_reset_password_token, :index_charity_workers_on_reset_password_token
  end
end
