module OrganizationsHelper
  def donation_info_msg 
     @organization.donation_info.blank? ? "We don't yet have any donation link for them." : link_to("Donate to #{@organization.name} now!", @organization.donation_info)
  end
end
