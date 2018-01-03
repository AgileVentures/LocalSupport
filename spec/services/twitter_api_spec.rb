require 'rails_helper'

  context 'Posting to twitter' do
    twitter_client = TwitterApi.new()
    desc = "Volunteer opportunity"
    long_tweet = "a" * 500
    it 'should be able to post 280 chars or less to twitter' do
      stub_request(:post, "https://api.twitter.com/1.1/statuses/update.json").
         with(body: {"status"=>"New #volunteer opportunity at https://www.harrowcn.org.uk/ - #{desc}"},
              headers: {}).
         to_return(status: 200, body: "", headers: {})
    end

    it 'should be able to parse a tweet' do
      current_max_tweet_length = 280
      result = twitter_client.parser(long_tweet)
      expect(result.length).to eq(current_max_tweet_length)
    end

    #Need to discuss with team what tests make sense to implement.
    # Currently These tests do nothing
    # Since we're posting to a third party API that should have their own
    # tests than what if any should we implement...
 end
