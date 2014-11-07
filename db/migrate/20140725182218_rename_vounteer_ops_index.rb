class RenameVounteerOpsIndex < ActiveRecord::Migration
  def change
    #this is no longer needed in rails 4 since AR is apparently now smart enough to change the indices when tables change
  end
end
