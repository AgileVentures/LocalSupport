class RemoveRegisteredWorkingFieldsForConfirmation < ActiveRecord::Migration
  def change
    remove_column :organisations, :registered_in_harrow, :boolean
    remove_column :organisations, :works_in_harrow, :boolean
  end
end
