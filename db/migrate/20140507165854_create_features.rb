class CreateFeatures < ActiveRecord::Migration
  def up
    create_table :features do |t|
      t.string :name
      t.boolean :active, default: false
    end

    Feature.create(name: :volunteer_ops_create)
    Feature.create(name: :volunteer_ops_list)

  end

  def down
    # Feature.find_by(name: :volunteer_ops_create).destroy
    # Feature.find_by(name: :volunteer_ops_list).destroy

    drop_table :features


  end

end
