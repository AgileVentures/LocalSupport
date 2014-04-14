module VolunteerOpsHelper
  def button_text object
    object.new_record? ? 'Create Volunteer Opportunity' : 'Update Volunteer Opportunity'
  end
end