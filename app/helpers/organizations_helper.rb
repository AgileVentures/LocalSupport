module OrganizationsHelper
  def charity_admin_display_msg
    if @organization.users.empty?
      "This organisation has no admins yet"
    else
      @organization.users.map {|user| user.email}.join(", ")
    end
  end
end
