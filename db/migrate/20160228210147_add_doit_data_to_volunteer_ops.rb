class AddDoitDataToVolunteerOps < ActiveRecord::Migration
  def change
    add_column :volunteer_ops, :source, :string
    add_column :volunteer_ops, :doit_op_link, :string
    add_column :volunteer_ops, :doit_op_id, :string
    add_column :volunteer_ops, :doit_org_link, :string
    add_column :volunteer_ops, :doit_org_name, :string
    add_column :volunteer_ops, :ops_lng, :float
    add_column :volunteer_ops, :ops_lat, :float
  end
end
