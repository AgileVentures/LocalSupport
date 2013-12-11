Then(/^I should see an approve cookie policy message$/) do
  expect(page).to have_css(".alert")
  expect(page).to have_content("This site uses cookies.")
  expect(page).to have_xpath("//a[@id=\"accept_cookies\"]")
  expect(page).to have_xpath("//a[@href=\"#{cookies_allow_path}\"]")
  expect(page).to have_xpath("//a[@id=\"deny_cookies\"]")
  expect(page).to have_xpath("//a[@href=\"#{cookies_deny_path}\"]")
end

Then(/^I should not see an approve cookie policy message$/) do
  page.should_not have_css(".alert")
  page.should_not have_content("This site uses cookies.")
  page.should_not have_xpath("//a[@id=\"accept_cookies\"]")
  page.should_not have_xpath("//a[@href=\"#{cookies_allow_path}\"]")
  page.should_not have_xpath("//a[@id=\"deny_cookies\"]")
  page.should_not have_xpath("//a[@href=\"#{cookies_deny_path}\"]")
end