class AddCategoryModel < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.string :name
      t.integer :charity_commission_id
      t.string :charity_commission_name

      t.timestamps
    end
  end

  def down
    drop_table :categories
  end
end
