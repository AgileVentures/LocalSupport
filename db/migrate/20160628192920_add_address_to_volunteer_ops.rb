class AddAddressToVolunteerOps < ActiveRecord::Migration[4.2]
  def change
    add_column :volunteer_ops, :address, :string
    add_column :volunteer_ops, :postcode, :string
  end
end
