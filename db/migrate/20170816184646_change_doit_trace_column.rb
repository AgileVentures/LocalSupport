class ChangeDoitTraceColumn < ActiveRecord::Migration[4.2]
  def change
    add_column :doit_traces, :doit_volop_id, :string
    add_index :doit_traces, :doit_volop_id
  end
end
