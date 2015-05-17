Then (/^I should see an "Accept Proposed Organisation" button$/) do
  expect(page).to have_link "Accept"
end
Then (/^I should see a "Reject Proposed Organisation" button$/) do
  expect(page).to have_link "Reject"
end
