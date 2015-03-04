class AddSiteadminToUser < ActiveRecord::Migration
  def change
    add_column :users, :siteadmin, :boolean, default: false
  end
end
