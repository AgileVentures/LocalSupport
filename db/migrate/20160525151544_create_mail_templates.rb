class CreateMailTemplates < ActiveRecord::Migration
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
