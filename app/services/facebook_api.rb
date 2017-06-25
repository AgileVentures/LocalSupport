class FacebookApi
  attr_reader :client

  def initialize
    @client = Koala::Facebook::API.new()
  end

  def post_to_facebook(msg)
    client.put_connections("me", "feed", message: msg)
  end
end