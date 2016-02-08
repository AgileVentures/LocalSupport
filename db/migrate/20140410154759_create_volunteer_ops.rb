class CreateVolunteerOps < ActiveRecord::Migration
  def change
    create_table :volunteer_ops do |t|
      t.string :title
      t.text :description
      t.references :organization

      t.timestamps null: true
    end
    add_index :volunteer_ops, :organization_id
  end
end
