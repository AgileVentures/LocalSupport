class RemovePostcodeColumnFromTables < ActiveRecord::Migration
  def up
    remove_column :organizations, :postcode
  end

  def down
    change_table :organizations do |t|
      t.string :postcode
    end
  end
end
