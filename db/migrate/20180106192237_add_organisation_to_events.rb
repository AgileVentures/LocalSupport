class AddOrganisationToEvents < ActiveRecord::Migration
  def change
  	add_reference :events, :organisation, foreign_key: true	
  end
end
