require 'rails_helper'

describe TwitterApi do
  before(:all) do
    @twitter_client = TwitterApi.new()
    WebMock.allow_net_connect!
  end

  after(:all) do
    WebMock.disable_net_connect!
  end

  context 'Posting to twitter' do
    it 'should be able to post 140 chars or less to twitter' do
      number_of_tweets = @twitter_client.client.user.tweets_count
      tweet = "Test Tweet #{number_of_tweets}"
      @twitter_client.post_to_twitter(tweet)

      expect(@twitter_client.client.user.tweets_count).to eq(number_of_tweets + 1)
    end

    it 'should be able to truncate longer messages to 140 chars and post to twitter' do
      tweet = "This string is going to be greater than 140 characters so we can test that our truncate method is functioning correctly. This is number 140. All of these characters should be truncated."

      expect(@twitter_client.tweet_size(tweet).length).to eq(140)
    end

  end
end