require 'rails_helper'

describe TwitterHelper, :type => :helper do
  describe 'Configure Client' do
    it 'should have a consumer key' do
      expect(twitter_client.consumer_key).not_to be_nil
      expect(twitter_client.consumer_key).to eq(ENV["TWITTER_CONSUMER_KEY"])
    end
    it 'should have a consumer secret' do
      expect(twitter_client.consumer_secret).not_to be_nil
      expect(twitter_client.consumer_secret).to eq(ENV["TWITTER_CONSUMER_SECRET"])
    end
    it 'should have an access token' do
      expect(twitter_client.access_token).not_to be_nil
      expect(twitter_client.access_token).to eq(ENV["TWITTER_ACCESS_TOKEN"] )
    end
    it 'should have a secret access token' do
      expect(twitter_client.access_token_secret).not_to be_nil
      expect(twitter_client.access_token_secret).to eq(ENV["TWITTER_ACCESS_TOKEN_SECRET"])
    end
  end

  describe 'tweet_size' do
    it 'should truncate long messages to 140 characters' do
      msg = "This string is going to be greater than 140 characters so we can test that our truncate method is functioning correctly. This is number 140. All of these characters should be truncated."

      tweet = tweet_size(msg)

      expect(tweet.length).to eq(140)
      expect(tweet).to eq("This string is going to be greater than 140 characters so we can test that our truncate method is functioning correctly. This is number 140.")
    end

    it 'should not alter messages less than 140 characters' do
      msg = "Short but sweet tweet!"
      tweet = tweet_size(msg)
      expect(tweet).to eq(msg)
    end
  end
end