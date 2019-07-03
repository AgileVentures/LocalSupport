class CreateSelfCareCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :self_care_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
