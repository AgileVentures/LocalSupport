class CreateMailTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :mail_templates do |t|
      t.text :name
      t.text :body
      t.text :footnote
      t.string :email

      t.timestamps null: false
    end
  end
end
