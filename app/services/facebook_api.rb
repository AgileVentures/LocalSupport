class FacebookApi
  attr_reader :graph

  # Create the facebook page and app
  # Then generate a permanent access token
  # Steps for generating a permanent access token:
  # https://stackoverflow.com/questions/17197970/facebook-permanent-page-access-token
  # https://www.youtube.com/watch?v=FtboHvg3HtY
  # After that also need to set permissions

  def initialize
    @graph = Koala::Facebook::API.new
  end

  def post volop
    url='https://www.harrowcn.org.uk/'
    msg = "New volunteer opportunity: #{volop.title} - For more information visit #{url}"
    graph.put_wall_post msg
  end
end
