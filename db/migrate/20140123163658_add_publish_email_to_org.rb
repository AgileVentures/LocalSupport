class AddPublishEmailToOrg < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :publish_email, :boolean, :default => true
  end
end
