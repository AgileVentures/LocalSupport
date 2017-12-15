class AddCategoryModel < ActiveRecord::Migration[4.2]
  def up
    create_table :categories do |t|
      t.string :name
      t.integer :charity_commission_id
      t.string :charity_commission_name

      t.timestamps null: true
    end
  end

  def down
    drop_table :categories
  end
end
