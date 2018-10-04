class DropTableClickThroughs < ActiveRecord::Migration[5.1]
  def change
    drop_table :click_throughs
  end
end
