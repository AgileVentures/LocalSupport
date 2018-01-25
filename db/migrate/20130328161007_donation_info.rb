class DonationInfo < ActiveRecord::Migration[4.2]
  def up
    add_column :organizations, :donation_info, :text
  end

  def down
    remove_column :organizations, :donation_info
  end
end
