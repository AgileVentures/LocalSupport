class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :address
      t.string :postcode
      t.string :email
      t.text :description
      t.string :website
      t.string :telephone

      t.timestamps null: true
    end
  end
end
