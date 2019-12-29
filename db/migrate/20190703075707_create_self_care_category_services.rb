class CreateSelfCareCategoryServices < ActiveRecord::Migration[5.2]
  def change
    create_table :self_care_category_services do |t|
      t.references :self_care_category, foreign_key: true
      t.references :service, foreign_key: true

      t.timestamps
    end
  end
end
