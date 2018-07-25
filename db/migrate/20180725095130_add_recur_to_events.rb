class AddRecurToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :recur, :text
  end
end
