class AddPublishAddressToOrg < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :publish_address, :boolean, :default => false
  end
end
