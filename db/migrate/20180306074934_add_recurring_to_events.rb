class AddRecurringToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :recurring, :text
  end
end
