class AddNonprofitConfirmationToBaseOrganisation < ActiveRecord::Migration
  def change
    add_column :organisations, :non_profit, :boolean
  end
end
