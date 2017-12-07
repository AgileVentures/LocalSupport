class AddEventsFeature < ActiveRecord::Migration[4.2]
  def change
    Feature.create(name: :events)
  end

  def down
    Feature.find_by(name: :events).destroy  end
end
