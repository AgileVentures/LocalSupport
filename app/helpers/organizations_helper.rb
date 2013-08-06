module OrganizationsHelper
  def donation_info_msg 
     @organization.donation_info.blank? ? "We don't yet have any donation link for them." : link_to("Donate to #{@organization.name} now!", @organization.donation_info, {:target => '_blank'})
  end
  def charity_admin_display_msg
    return "<div>This organization has no admins yet</div>" unless @organization.users
    render :partial => 'organizations/charity_admin_display'
  end
end
