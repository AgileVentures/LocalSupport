module VolunteerOpsHelper
  def button_text object
    object.new_record? ? 'Create Volunteer Opportunity' : 'Update Volunteer Opportunity'
  end
  
  def has_diff_volunteer_op_location? object
    !object.different_address
  end
end
