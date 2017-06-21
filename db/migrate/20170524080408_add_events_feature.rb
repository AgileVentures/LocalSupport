class AddEventsFeature < ActiveRecord::Migration
  def change
    Feature.create(name: :events)
  end

  def down
    Feature.find_by(name: :events).destroy  end
end
