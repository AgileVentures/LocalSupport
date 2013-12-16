Then(/^I should see an approve cookie policy message$/) do
  expect(page).to have_css("#cookie-message")
  expect(page).to have_content("We use cookies to give you the best experience on our website")
  expect(page).to have_xpath("//a[@id=\"accept_cookies\"]")
  expect(page).to have_xpath("//a[@href=\"#{cookies_allow_path}\"]")
end

Then(/^I should not see an approve cookie policy message$/) do
  page.should_not have_css("#cookie-message")
  page.should_not have_content("We use cookies to give you the best experience on our website.")
  page.should_not have_xpath("//a[@id=\"accept_cookies\"]")
  page.should_not have_xpath("//a[@href=\"#{cookies_allow_path}\"]")
end