Then (/^I should( not)? see an "Accept Proposed Organisation" button$/) do |negation|
  unless negation
    expect(page).to have_link "Accept"
  end
  expect(page).not_to have_link "Accept"
end
Then (/^I should( not)? see a "Reject Proposed Organisation" button$/) do |negation|
  unless negation
    expect(page).to have_link "Reject"
  end
  expect(page).not_to have_link "Reject"
end
