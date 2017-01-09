module VolunteerOpsHelper
  def button_text object
    object.new_record? ? 'Create a Volunteer Opportunity' : 'Update a Volunteer Opportunity'
  end

  def link_to_vol_op(obj, type, html_options = {})
    html_options[:target] = '_blank' unless obj.source == 'local'
    return link_to(obj.title, obj.link, html_options) if type == :title
    link_to(obj.organisation_name, obj.organisation_link, html_options)
  end
end
