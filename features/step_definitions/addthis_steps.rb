Then(/^I should see the AddThis sharing sidebar$/) do
  page.should have_css '.addthis-smartlayers'
end
