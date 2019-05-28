class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.integer :organisation_id, foreign_key: true
      t.string :contact_id
      t.string :display_name
      t.text :service_activities
      t.string :postal_code
      t.string :office_main_phone_general_phone
      t.string :office_main_email
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
