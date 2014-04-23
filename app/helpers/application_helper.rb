module ApplicationHelper
  # from http://stackoverflow.com/questions/1293573/rails-smart-text-truncation
  def smart_truncate(sentence, char_limit = 128)
      sentence = sentence.to_s
      size =0
      sentence.split().reject do |word|
        size+=word.size()
        size>char_limit
      end.join(" ")+(sentence.size()>char_limit ? " "+ "..." : "" )
  end

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

  # def after_sign_in_path_for(resource)
  #   redirect_to  root_url
  # end

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
end


