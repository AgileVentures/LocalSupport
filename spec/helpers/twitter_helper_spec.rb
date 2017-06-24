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
end