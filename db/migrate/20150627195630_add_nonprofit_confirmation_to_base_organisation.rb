class AddNonprofitConfirmationToBaseOrganisation < ActiveRecord::Migration
  def change
    add_column :organisations, :non_profit, :boolean
    add_column :organisations, :registered_in_harrow, :boolean
    add_column :organisations, :works_in_harrow, :boolean
  end
end
