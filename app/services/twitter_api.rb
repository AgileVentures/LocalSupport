class TwitterApi
  include Twitter::Validation
  attr_reader :client

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end

  def post_to_twitter(msg, url = "https://www.harrowcn.org.uk/")
   # parse_results = parse_tweet(msg + " " + url)
   # tweet = msg[parse_results.display_range_start...parse_results.display_range_end]
   # parse_results = parse_tweet("test test test")
   # client.update("test test test 1") if parse_results.valid
   tweet = msg + " " + url
   byebug
   result = parse_tweet(tweet)
   client.update(msg[result.display_range_start...result.display_range_end] + " " + url)
  end
end
