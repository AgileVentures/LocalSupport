class CharityWorkersAdmin < ActiveRecord::Migration
  def up
    add_column :charity_workers, :admin, :boolean, {:default => false}
  end

  def down
  end
end
