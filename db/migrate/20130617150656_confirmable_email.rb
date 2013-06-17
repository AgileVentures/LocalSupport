class ConfirmableEmail < ActiveRecord::Migration

  def up
    change_table :users do |t|
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
    end
  end

  def down
    change_table :users do |t|
      t.remove_column :confirmation_token
      t.remove_column :confirmed_at
      t.remove_column :confirmation_sent_at
    end
  end
end
