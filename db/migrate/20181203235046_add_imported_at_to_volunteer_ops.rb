class AddImportedAtToVolunteerOps < ActiveRecord::Migration[5.1]
  def change
    add_column :volunteer_ops, :imported_at, :datetime
  end
end
