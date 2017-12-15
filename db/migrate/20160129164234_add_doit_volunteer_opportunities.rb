class AddDoitVolunteerOpportunities < ActiveRecord::Migration[4.2]
  def up
    Feature.create(name: :doit_volunteer_opportunities)
  end

  def down
    Feature.find_by(name: :doit_volunteer_opportunities).destroy
  end
end
