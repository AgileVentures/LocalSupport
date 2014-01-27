class AddPublishEmailToOrg < ActiveRecord::Migration
  def change
    add_column :organizations, :publish_email, :boolean, :default => true
  end
end
