class AddDoitDataToVolunteerOps < ActiveRecord::Migration
  def change
    add_column :volunteer_ops, :source, :string, default: 'local'
    add_column :volunteer_ops, :doit_op_link, :string
    add_column :volunteer_ops, :doit_op_id, :string
    add_column :volunteer_ops, :doit_org_link, :string
    add_column :volunteer_ops, :doit_org_name, :string
    add_column :volunteer_ops, :longitude, :float
    add_column :volunteer_ops, :latitude, :float
  end
end
