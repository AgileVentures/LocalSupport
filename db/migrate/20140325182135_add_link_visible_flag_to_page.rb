class AddLinkVisibleFlagToPage < ActiveRecord::Migration
  def up
    add_column :pages, :link_visible, :boolean, :default => true
    Page.reset_column_information
    p = Page.find_by_permalink('404')
    (p.link_visible = false; p.save!) if p
   end
  def down
    remove_column :pages, :link_visible
  end
end

