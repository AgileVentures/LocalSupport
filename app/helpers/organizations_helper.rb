module OrganizationsHelper
  def charity_admin_display_msg
    if @organization.users.empty?
      "This organisation has no admins yet"
    else
      @organization.users.map {|user| user.email}.join(", ")
    end
  end
  #use join per sam
  def display_organization_categories categories
    categories.map(&:name).join(", ")
  end
end
