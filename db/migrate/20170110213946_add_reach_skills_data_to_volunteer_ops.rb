class AddReachSkillsDataToVolunteerOps < ActiveRecord::Migration
  def up
    add_column :volunteer_ops, :reachskills_org_name, :string
    add_column :volunteer_ops, :reachskills_org_link, :string

    Feature.create(name: :reachskills_volunteer_opportunities)
  end

  def down
    remove_column :volunteer_ops, :reachskills_org_name
    remove_column :volunteer_ops, :reachskills_org_link
    
    Feature.find_by(name: :reachskills_volunteer_opportunities).destroy
  end
end
