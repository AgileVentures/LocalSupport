class ContributorsController < ApplicationController
  layout 'full_width'
  require 'rubygems'
  require 'json'

  def show
    url = 'https://api.github.com/repos/AgileVentures/LocalSupport/contributors'
    uri = URI.parse url
    request = Net::HTTP::Get.new(uri.request_uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(request)
    json_data = response.body
    @contributors = JSON.parse(json_data)
  end

end