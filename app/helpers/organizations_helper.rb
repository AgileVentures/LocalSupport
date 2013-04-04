module OrganizationsHelper
  def donation_info_msg 
     @organization.donation_info ? link_to("Donate to #{@organization.name} now!", @organization.donation_info) : "We don't yet have any donation link for them."
  end
end
