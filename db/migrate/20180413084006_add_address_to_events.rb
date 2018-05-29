class AddAddressToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :address, :string
  end
end
