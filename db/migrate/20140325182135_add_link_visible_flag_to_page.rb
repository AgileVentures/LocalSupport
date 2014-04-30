class AddLinkVisibleFlagToPage < ActiveRecord::Migration
  def up
    add_column :pages, :link_visible, :boolean, :default => true
    Page.reset_column_information
    Page.find_by_permalink('404').update_attributes(:link_visible => false)
  end
  def down
    remove_column :pages, :link_visible
  end
end

