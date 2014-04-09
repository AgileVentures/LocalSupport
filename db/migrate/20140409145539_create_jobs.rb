class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.references :organization

      t.timestamps
    end
    add_index :jobs, :organization_id
  end
end