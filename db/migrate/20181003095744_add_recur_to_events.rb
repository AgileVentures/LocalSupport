class AddRecurToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :occur, :integer, default: 0
  end
end
