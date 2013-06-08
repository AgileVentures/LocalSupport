class CharityWorkerAddOrganization < ActiveRecord::Migration
  def up
    change_table :charity_workers do |t|
      t.references :organization
    end
  end

  def down
    change_table :charity_workers do |t|
      t.remove_column :organization_id
    end
  end
end
