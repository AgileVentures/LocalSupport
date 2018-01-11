class AddLongLatToOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :latitude, :float
    add_column :organizations, :longitude, :float
    add_column :organizations, :gmaps, :boolean
  end
end
