module VolunteerOpsHelper
  def button_text object
    object.new_record? ? 'Create a Volunteer Opportunity' : 'Update a Volunteer Opportunity'
  end
  
  def has_diff_volunteer_op_location? object
    !object.volunteer_op_loc.empty?
  end
end
