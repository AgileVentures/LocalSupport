class AddTypeToBaseOrganisation < ActiveRecord::Migration
  def change
    add_column :base_organisations, :type, :string, default: "Organisation"
  end
end
