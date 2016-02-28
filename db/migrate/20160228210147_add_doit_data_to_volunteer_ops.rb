class AddDoitDataToVolunteerOps < ActiveRecord::Migration
  def change
    add_column :volunteer_ops, :postcode, :string
    add_column :volunteer_ops, :ops_url, :string
    add_column :volunteer_ops, :ops_lng, :float
    add_column :volunteer_ops, :ops_lat, :float
  end
end
