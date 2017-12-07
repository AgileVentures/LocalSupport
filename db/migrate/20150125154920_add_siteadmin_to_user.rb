class AddSiteadminToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :siteadmin, :boolean, default: false
  end
end
