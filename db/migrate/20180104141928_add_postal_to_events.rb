class AddPostalToEvents < ActiveRecord::Migration
  def change
    add_column :events, :postal, :string, :null => true
  end

  def down
  	remove_column :events, :postal
  end
end
