module VolunteerOpsHelper
  def button_text object
    object.new_record? ? 'Create a Volunteer Opportunity' : 'Update Volunteer Opportunity'
  end

  def link_to_vol_op(obj, type, html_options = {})
    return  get_local_source_link(obj, type, html_options) if obj.source == 'local'
    html_options[:target] = '_blank'
    get_external_source_link(obj, type, html_options)
  end

  def get_local_source_link(obj, type, html_options)
    if type == :title
      link_to_and_track(obj.title, volunteer_op_url(obj), html_options)
    else
      link_to_and_track(obj.organisation_name,
                        organisation_url(obj.organisation_link.slug),
                        html_options)
    end
  end

  def get_external_source_link(obj, type, html_options)
    if type == :title
      link_to_and_track(obj.title, obj.link, html_options) if type == :title
    else
      link_to_and_track(obj.organisation_name, obj.organisation_link, html_options)
    end
  end
end
