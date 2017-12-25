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

    it 'should be able to post 280 chars or more to twitter' do
   #   number_of_tweets = @twitter_client.client.user.tweets_count
      tweet = "Test Tweet This string is going to be greater than 280 characters so we can test that our truncate method is functioning correctly. This is number 140. This string is going to be greater than 280 characters so we can test that our truncate method is functioning correctly. This is number 280. All of these characters should be truncated."
      @twitter_client.post_to_twitter(tweet)
   #   expect(@twitter_client.client.user.tweets_count).to eq(number_of_tweets + 1)
    end

  end
end
