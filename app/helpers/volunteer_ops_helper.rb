module VolunteerOpsHelper
  def button_text object
    object.new_record? ? 'Create a Volunteer Opportunity' : 'Update a Volunteer Opportunity'
  end

  def link_to_vol_op(obj, name, link, html_options = {})
    html_options.merge!(target: "_blank") unless obj.source == 'local'
    link_to(name, link, html_options)
  end
end
