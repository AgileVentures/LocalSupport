class CharityWorkersAdmin < ActiveRecord::Migration[4.2]
  def up
    add_column :charity_workers, :admin, :boolean, {:default => false}
  end

  def down
    remove_column :charity_workers, :admin
  end
end
