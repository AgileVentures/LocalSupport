class AddReachSkillsDataToVolunteerOps < ActiveRecord::Migration
  def change
    add_column :volunteer_ops, :reachskills_org_name, :string
    add_column :volunteer_ops, :reachskills_org_link, :string
  end
end
