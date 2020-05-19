Then /^I should (.*)see the navbar on the page/ do |see_or_not_see|
  see_or_not_see.strip!
  if see_or_not_see == 'not'
    page.should_not have_content("Search for local voluntary and community organisations")
  else
    page.should have_content("Search for local voluntary and community organisations")
  end
end