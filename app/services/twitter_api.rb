require 'twitter-text'
require 'twitter'
class TwitterApi
  include Twitter::TwitterText::Validation
  attr_reader :client

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end

  def tweet volop
    url='https://www.harrowcn.org.uk/'
    msg = "New #volunteer opportunity: #{volop.title} visit #{url} for more information"
    valid_tweet = parse msg
    client.update valid_tweet
  end

  def parse msg
    parse_result = parse_tweet msg
    msg[parse_result[:valid_range_start]..parse_result[:valid_range_end]]
  end

  def tweet_new_opportunities source
    within_one_day = (Time.current - 1.day)..Time.current
    volops = VolunteerOp.where(source: source).where created_at: within_one_day
    volops.each { |volop| tweet volop }
  end
end
