class AddStepToOrganisation < ActiveRecord::Migration
  def change
    change_table :organisations do |t|
      t.column :step, :integer, default: 0
    end
  end
end
