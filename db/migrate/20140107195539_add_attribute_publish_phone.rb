class AddAttributePublishPhone < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :publish_phone, :boolean, :default => false
  end
end
