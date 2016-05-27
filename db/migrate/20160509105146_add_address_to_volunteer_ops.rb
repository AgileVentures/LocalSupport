class AddAddressToVolunteerOps < ActiveRecord::Migration
  def change
    add_column :volunteer_ops, :address, :string
    add_column :volunteer_ops, :postcode, :string
  end
end
