class CreateDoitTraces < ActiveRecord::Migration[4.2]
  def change
    create_table :doit_traces do |t|
      t.datetime :published_at
      t.references :volunteer_op, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
