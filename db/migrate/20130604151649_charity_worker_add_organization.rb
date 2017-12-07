class CharityWorkerAddOrganization < ActiveRecord::Migration[4.2]
  def up
    change_table :charity_workers do |t|
      t.references :organization
    end
  end

  def down
    change_table :charity_workers do |t|
      t.remove :organization_id
    end
  end
end
