class AddMissingIndicies < ActiveRecord::Migration
  def up
    add_index :organisations, :deleted_at
    add_index :users, :deleted_at
    add_index :users, :organisation_id
  end

  def down
    remove_index :organisations, :deleted_at
    remove_index :users, :deleted_at
    remove_index :users, :organisation_id
  end
end
