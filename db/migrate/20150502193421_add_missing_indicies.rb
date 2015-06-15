class AddMissingIndicies < ActiveRecord::Migration
  def up
    add_index :users, :organisation_id
    add_index :categories_organisations, :organisation_id
    add_index :categories_organisations, :category_id
  end

  def down
    remove_index :users, :organisation_id
    remove_index :categories_organisations, :organisation_id
    remove_index :categories_organisations, :category_id
  end
end
