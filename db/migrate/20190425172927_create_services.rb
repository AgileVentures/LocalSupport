class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :contact_id
      t.string :display_name
      t.text :service_activities
      t.string :postal_code
      t.string :office_main_phone_general_phone
      t.string :office_main_email
      t.string :website
      t.string :delivered_by_organization_name
      t.string :where_we_work
      t.string :self_care_one_to_one_or_group
      t.string :self_care_service_category
      t.string :self_care_category_secondary
      t.string :self_care_service_agreed
      t.string :location_type
      t.string :street_address
      t.string :street_number
      t.string :street_name
      t.string :street_unit
      t.string :supplemental_address_1
      t.string :supplemental_address_2
      t.string :supplemental_address_3
      t.string :city
      t.integer :latitude
      t.integer :longitude
      t.string :address_name
      t.string :county
      t.string :state
      t.string :country
      t.string :groups
      t.string :tags
      t.string :activity_type
      t.string :summary_of_activities
      t.string :beneficiaries

      t.timestamps
    end
  end
end
