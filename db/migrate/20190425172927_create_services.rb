class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.integer :organisation_id, foreign_key: true
      t.string :contact_id
      t.string :name
      t.text :description
      t.string :postal_code
      t.string :telephone
      t.string :email
      t.string :website
      t.string :where_we_work
      t.integer :latitude
      t.integer :longitude
      t.string :address
      t.string :activity_type
      t.string :beneficiaries
      t.string :imported_from
      t.datetime :imported_at

      t.timestamps
    end
  end
end
