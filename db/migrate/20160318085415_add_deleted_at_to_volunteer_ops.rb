class AddDeletedAtToVolunteerOps < ActiveRecord::Migration
  def change
    add_column :volunteer_ops, :deleted_at, :datetime
    add_index :volunteer_ops, :deleted_at
  end
end
