module OrganizationsHelper
  def charity_admin_display_msg
    if @organization.users.empty?
      simple_format("\n\nThis organisation has no admins yet.")
    else
      simple_format("\n\nThe following users are administrators for \n<strong>#{@organization.name}:</strong>
      #{@organization.users.map {|user| user.email}.join("\n")}")
    end
  end
end
