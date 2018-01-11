class AddOrganisationToEvents < ActiveRecord::Migration[4.2]
  def change
  	add_reference :events, :organisation, foreign_key: true	
  end
end
