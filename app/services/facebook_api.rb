class FacebookApi
  attr_reader :client

  def initialize
    @client = Koala::Facebook::API.new
  end

  def post volop
    url='https://www.harrowcn.org.uk/'
    msg = "New volunteer opportunity: #{volop.title} - For more information visit #{url}"
    client.put_connections('me', 'feed', message: msg)
  end
end
