class AddDeletedAtToOrganization < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :deleted_at, :datetime
  end
end
