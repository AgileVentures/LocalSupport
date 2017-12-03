module ApplicationHelper
  include StringUtility

  def markdown(text)
    red_carpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true)
    red_carpet.render(text).html_safe
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def parent_layout(layout) # http://andre.arko.net/2013/02/02/nested-layouts-on-rails--31/
    @view_flow.set(:layout, output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def cookie_policy_accepted?
    cookies['cookie_policy_accepted'].present?
  end

  def active_if(controller)
    'active' if params[:controller] == controller
  end

  def feature_active?(flag)
    Feature.active?(flag.to_sym)
  end

  def bootstrap_class_for flash_type
    case flash_type
    when 'warning'
      'alert-warning'
    when 'notice', 'success'
      'alert-success'
    else
      'alert-danger'
    end
  end

  def gmap_key_value_for_url
    return '' if ENV['GMAP_API_KEY'].nil?
    "&key=#{ENV['GMAP_API_KEY']}"
  end

  def link_to_and_track(title, url='#', options = {})
    link_to title, click_through_go_path(url: url), options: options
  end
end


