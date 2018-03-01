class RemoveAboutOrganizationFromVolunteerOps < ActiveRecord::Migration[5.1]
  def change
    remove_column :volunteer_ops, :about_organization, :string
  end
end
