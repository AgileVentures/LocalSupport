Then(/^the "(.*?)" label should display "(.*?)" as a tooltip$/) do |label, tooltip|
  page.should have_css("div[title=\"#{tooltip}\"][data-toggle=\"tooltip\"]:contains('#{label}')")
end
