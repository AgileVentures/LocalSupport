module OrganisationsHelper
  def charity_admin_display_msg
    if @organisation.users.empty?
      "This organisation has no admins yet"
    else
      @organisation.users.map {|user| user.email}.join(", ")
    end
  end
end
