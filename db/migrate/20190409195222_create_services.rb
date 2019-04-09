class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :delivered_by_organization_name
      t.string :display_name
      t.string :self_care_one_to_one_or_group
      t.text :service_activities
      t.string :self_care_service_category
      t.string :self_care_category_secondary
      t.string :office_main_phone_general_phone
      t.string :office_main_email
      t.string :self_care_service_agreed
      t.string :where_we_work
      t.string :website
      t.string :contact_id

      t.timestamps
    end
  end
end
