class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value = add_url_protocol value
    record.errors.add attribute, (options[:message] || "Please enter a valid URL") unless
          value =~ /\A(?:http:\/\/|https:\/\/|)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
  end

  def add_url_protocol url
    url.prepend('http://') if needs_url_protocol? url
  end

  private
  def needs_url_protocol? url 
    !valid_url_with_protocol?(url) && url.length > 0
  end

  def valid_url_with_protocol? url
    url[/\Ahttp:\/\//] || url[/\Ahttps:\/\//]
  end
end
