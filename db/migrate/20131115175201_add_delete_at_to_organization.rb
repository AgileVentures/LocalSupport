class AddDeleteAtToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :deleted_at, :time
  end
end
