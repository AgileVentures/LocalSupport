class AddLinkVisibleFlagToPage < ActiveRecord::Migration
  def change
    add_column :pages, :link_visible, :boolean
  end
end
