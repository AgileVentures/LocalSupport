Then(/^I should see the AddThis sharing sidebar$/) do
  expext(page).to have_css '.addthis-smartlayers'
end
