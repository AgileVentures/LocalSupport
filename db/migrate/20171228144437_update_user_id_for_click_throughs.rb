class UpdateUserIdForClickThroughs < ActiveRecord::Migration[4.2]
  def up
    change_column :click_throughs, :user_id, 'integer USING CAST(user_id AS integer)'
  end
  
  def down
    change_column :click_throughs, :user_id
  end
end
