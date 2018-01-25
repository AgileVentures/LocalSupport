class AddLatLongToEvents < ActiveRecord::Migration[4.2]
  def change
  	add_column :events, :latitude, :float
  	add_column :events, :longitude, :float
  end
end
