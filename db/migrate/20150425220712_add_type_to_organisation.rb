class AddTypeToOrganisation < ActiveRecord::Migration[4.2]
  def change
    add_column :organisations, :type, :string, default: "Organisation"
  end
end
