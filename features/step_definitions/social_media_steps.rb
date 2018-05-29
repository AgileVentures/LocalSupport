Given /^I run the update social media task$/ do
  UpdateSocialMedia.new.post_new_volops_from_partner_sites
end

Then(/^there should be (\d+) posts? to twitter$/) do |number_posts|
  expect_any_instance_of(TwitterApi).to receive(:tweet).exactly(number_posts.to_i).times
end
