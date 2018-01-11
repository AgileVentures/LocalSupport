class AddNonprofitConfirmationToBaseOrganisation < ActiveRecord::Migration[4.2]
  def change
    add_column :organisations, :non_profit, :boolean
  end
end
