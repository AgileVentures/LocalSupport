class CategoriesOrganizations < ActiveRecord::Migration
  def up
    create_table :categories_organizations do |t|
     t.references :category
     t.references :organization
    end
  end

  def down
    drop_table :categories_organizations
  end
end
