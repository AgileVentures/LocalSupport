Given(/^I have approved cookie policy$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I have not approved cookie policy$/) do
  #This is wrong... ;-)
  debugger
  expect(cookies_accepted?).to eq false
end

Then(/^I should see an approve cookie policy message$/) do
  expect(page).to have_css(".alert")
  expect(page).to have_content("This site uses cookies.")
  expect(page).to have_xpath("//a[@id=\"accept_cookies\"]")
  expect(page).to have_xpath("//a[@href=\"#{cookies_allow_path}\"]")
  expect(page).to have_xpath("//a[@id=\"deny_cookies\"]")
  expect(page).to have_xpath("//a[@href=\"#{cookies_deny_path}\"]")
end

Then(/^I should not see an approve cookie policy message$/) do
  pending # express the regexp above with the code you wish you had
end