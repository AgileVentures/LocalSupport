class TwitterAPI
  attr_reader :client

  def initialize
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def post_to_twitter(msg)
    client.update(tweet_size(msg))
  end

  def last_tweet
    last_tweet_id.full_text
  end

  def delete_last_tweet
    @client.destroy_status(last_tweet_id)
  end

  private

  def tweet_size(msg)
    msg[0..139]
  end

  def last_tweet_id
    @client.home_timeline.first
  end

end