class AddLinkVisibleFlagToPage < ActiveRecord::Migration
  def up
    add_column :pages, :link_visible, :boolean, :default => true
  end
  def down
    remove_column :pages, :link_visible
  end
end
