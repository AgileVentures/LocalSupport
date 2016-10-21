Then(/^I should see the AddThis sharing sidebar$/) do
  expect(page).to have_css '.addthis-smartlayers'
end
