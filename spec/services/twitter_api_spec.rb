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
      result = twitter_client.parse(long_tweet)
      expect(result.length).to eq(current_max_tweet_length)
    end

    it 'should be able to parse a short tweet' do
      result = twitter_client.parse("abc")
      expect(result).to eq("abc")
    end

    #Need to work on stubbing the request properly
  end
