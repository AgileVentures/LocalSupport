Given /^I run the update social media task$/ do
  UpdateSocialMedia.new.post_new_volops_from_partner_sites
end

Then(/^there should be (\d+) posts to twitter$/) do |number_posts|
  # https://github.com/bblimke/webmock#setting-expectations-in-rspec-on-webmock-module

  # expect(WebMock).to have_requested(:post, 'https://api.twitter.com/1.1/statuses/update.json', times: number_posts)

  expect(a_request(:post, 'https://api.twitter.com/1.1/statuses/update.json')).
      to have_been_made.times(number_posts)
end


# expect(WebMock).to have_requested(:post, 'https://api.twitter.com/1.1/statuses/update.json').
#       with { |req| req.body =~ /hangout\.test/ }

# expect(WebMock).to have_requested(:post, 'https://api.twitter.com/1.1/statuses/update.json').
#       with { |req| req.body =~ /hangout\.test/ }
