class AddPublishAddressToOrg < ActiveRecord::Migration
  def change
    add_column :organizations, :publish_address, :boolean, :default => false
  end
end
