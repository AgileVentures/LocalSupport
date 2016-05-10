class AddSlugToOrganisations < ActiveRecord::Migration
  def up
    add_column :organisations, :slug, :string
    
    add_index :organisations, :slug, unique: true
  end
  
  def down
    remove_index :organisations, :slug
    
    remove_column :organisations, :slug
  end
end
