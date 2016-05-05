class AddVolunteerOpLocationToVolunteerOp < ActiveRecord::Migration
  def change
    add_column :volunteer_ops, :volunteer_op_loc, :string
  end
end
