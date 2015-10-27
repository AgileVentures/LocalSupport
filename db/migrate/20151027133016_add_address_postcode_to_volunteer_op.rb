class AddAddressPostcodeToVolunteerOp < ActiveRecord::Migration
  def change
    add_column :volunteer_ops, :address, :string
    add_column :volunteer_ops, :postcode, :string
    add_column :volunteer_ops, :use_this_address_as_location_for_volunteer_opportunity, :string
  end
end
