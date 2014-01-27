class AddAttributePublishPhone < ActiveRecord::Migration
  def change
    add_column :organizations, :publish_phone, :boolean, :default => false
  end
end
