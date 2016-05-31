class CreateMailTemplates < ActiveRecord::Migration
  def change
    create_table :mail_templates do |t|
      t.text :text
      t.string :email
      t.text :footnote
      t.references :user

      t.timestamps null: false
    end
  end
end
