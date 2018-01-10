class UpdateUserIdForClickThroughs < ActiveRecord::Migration
  def change
    change_column :click_throughs, :user_id, 'integer USING CAST(user_id AS integer)'
  end
end
