Then (/^I should( not)? see an "Accept Proposed Organisation" button$/) do |negation|
  if negation
    expect(page).not_to have_link "Accept"
  else
      expect(page).to have_link "Accept"
  end
end
Then (/^I should( not)? see a "Reject Proposed Organisation" button$/) do |negation|
  if negation
    expect(page).not_to have_link "Reject"
  else
    expect(page).to have_link "Reject"
  end
end
