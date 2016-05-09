module VolunteerOpsHelper
  def button_text object
    object.new_record? ? 'Create Volunteer Opportunity' : 'Update Volunteer Opportunity'
  end
  
  def has_diff_location object
    object.different_address == "1"
  end
end
