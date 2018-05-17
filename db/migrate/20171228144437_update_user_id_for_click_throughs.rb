class UpdateUserIdForClickThroughs < ActiveRecord::Migration[4.2]
  def up
    change_column :click_throughs, :user_id, 'integer USING CAST(user_id AS integer)'
  end
  
  def down
    change_column :click_throughs, :user_id, 'varchar(50) USING CAST(user_id as varchar(50))'
  end
end
