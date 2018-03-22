require 'rails_helper'

RSpec.describe TwitterApi do
  context 'Posting to twitter' do
    twitter_client = TwitterApi.new()
    desc = "Volunteer opportunities"
    long_tweet = "a" * 5000
    volop = VolunteerOp.new title: long_tweet

    it 'should be able to post a long tweet to twitter' do
      expect_any_instance_of(Twitter::REST::Client).to receive(:update).once
      twitter_client.tweet volop
    end

    it 'should be able to post a short tweet to twitter' do
      volop.title = "title"
      expect_any_instance_of(Twitter::REST::Client).to receive(:update).once
      twitter_client.tweet volop
    end
  end
end
