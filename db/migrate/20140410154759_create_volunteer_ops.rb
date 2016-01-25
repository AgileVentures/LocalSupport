class CreateVolunteerOps < ActiveRecord::Migration
  def change
    create_table :volunteer_ops do |t|
      t.string :title
      t.text :description
      t.references :organization

      t.timestamps
    end

    add_index :volunteer_ops, :organization_id

    Feature.create(name: :volunteer_ops_create)
    Feature.create(name: :volunteer_ops_list)
  end
end
