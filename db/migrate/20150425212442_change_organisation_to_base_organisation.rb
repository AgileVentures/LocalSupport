class ChangeOrganisationToBaseOrganisation < ActiveRecord::Migration
  def self.up
    rename_table :organisations, :base_organisations
  end
  def self.down
    rename_table :base_organisations, :organisations
  end
end
