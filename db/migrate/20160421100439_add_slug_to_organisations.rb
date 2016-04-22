class AddSlugToOrganisations < ActiveRecord::Migration
  def up
    add_column :organisations, :slug, :string
    
    add_index :organisations, :slug, unique: true
    
    Organisation.find_each(&:save)
  end
  
  def down
    remove_index :organisations, :slug
    
    remove_column :organisations, :slug
  end
end
