class CategoriesOrganizations < ActiveRecord::Migration[4.2]
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
