require 'rails_helper'

  context 'Posting to twitter' do
    twitter_client = TwitterApi.new()
    desc = "Volunteer opportunities"
    long_tweet = "a" * 500
    volop = VolunteerOp.new title: "New opportunity"

    it 'should be able to post to twitter' do
      result = twitter_client.tweet volop
      expect(result).to be_truthy
    end

    it 'should be able to parse a tweet' do
      current_max_tweet_length = 280
      result = twitter_client.parse(long_tweet)
      expect(result.length).to eq(current_max_tweet_length)
    end

    it 'should be able to parse a short tweet' do
      result = twitter_client.parse("abc")
      expect(result).to eq("abc")
    end
  end
