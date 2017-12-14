module VolunteerOpsHelper
  def button_text object
    object.new_record? ? 'Create a Volunteer Opportunity' : 'Update Volunteer Opportunity'
  end

  def link_to_vol_op(obj, type, html_options = {})
    html_options[:target] = '_blank' unless obj.source == 'local'

    if obj.source == 'local'
      return link_to_and_track(obj.title, volunteer_op_url(obj), html_options) if type == :title
      link_to_and_track(obj.organisation_name, organisation_url(obj), html_options)
    else
      return link_to_and_track(obj.title, obj.link, html_options) if type == :title
      link_to_and_track(obj.organisation_name, obj.organisation_link, html_options)
    end
  end
end
