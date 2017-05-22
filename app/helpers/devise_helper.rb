module DeviseHelper
  # A simple way to show error messages for the current devise resource. If you need
  # to customize this method, you can either overwrite it in your application helpers or
  # copy the views to your application.
  #
  # This method is intended to stay simple and it is unlikely that we are going to change
  # it to add more behavior or options.
  def devise_error_messages!
    return "" if resource.errors.empty?

    errors = resource.errors
    reset_token_error = errors.to_hash.fetch(:reset_password_token,'')
    if reset_token_error.include? 'has expired, please request a new one'
      errors.add(:base, :reset_password_token_expired)
      errors[:reset_password_token].delete 'has expired, please request a new one'
    end
      
    messages = errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    # empty out error messages so they don't linger
    resource.errors.clear

    html = <<-HTML
    <div id="error_explanation">
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end
