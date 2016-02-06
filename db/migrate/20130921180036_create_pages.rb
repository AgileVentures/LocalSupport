class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :permalink
      t.text :content

      t.timestamps null: true
    end
    add_index :pages, :permalink
  end
end
