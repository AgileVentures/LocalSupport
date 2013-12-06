class ContributorsController < ApplicationController
  require 'rubygems'
  require 'json'

  def show
    url = 'https://api.github.com/repos/tansaku/LocalSupport/contributors'

    response = Net::HTTP.get_response(URI.parse(url))
    data = response.body
    @contributors = JSON.parse(data)
  end

end