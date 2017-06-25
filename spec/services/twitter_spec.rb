require 'rails_helper'
require './app/services/twitter.rb'
require 'byebug'

describe TwitterAPI do
  before(:all) do
    @twitter_client = TwitterAPI.new()
    WebMock.allow_net_connect!
  end

  after(:each) do
    @twitter_client.delete_last_tweet
  end

  after(:all) do
    WebMock.disable_net_connect!
  end

  context 'Posting to twitter' do
    it 'should be able to post 140 chars or less to twitter' do
      tweet = "Test tweet"
      @twitter_client.post_to_twitter(tweet)
      expect(@twitter_client.last_tweet).to eq(tweet)
    end

    it 'should be able to truncate longer messages to 140 chars and post to twitter' do
      tweet = "This string is going to be greater than 140 characters so we can test that our truncate method is functioning correctly. This is number 140. All of these characters should be truncated."
      @twitter_client.post_to_twitter(tweet)
      expect(@twitter_client.last_tweet).to eq(tweet[0..139])
    end

  end
end