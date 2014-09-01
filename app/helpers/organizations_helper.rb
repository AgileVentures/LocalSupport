module OrganizationsHelper
  def charity_admin_display_msg
    if @organization.users.empty?
      "This organisation has no admins yet"
    else
      @organization.users.map {|user| user.email}.join(", ")
    end
  end

  def display_organization_categories category_names
    category_names.reduce("") do |memo, cat_name|
      memo.present? ? "#{memo}, #{cat_name}" : "#{cat_name}"
    end
  end
end
