Then /the following tooltips should exist/ do |tooltips_table|
  tooltips_table.hashes.each do |tooltip|
    debugger
    page.should have_css("td[title=\"#{tooltip['tooltip']}\"][data-toggle=\"tooltip\"]:contains('#{tooltip['label']}')")
  end
end

Then(/^the "(.*?)" label should display "(.*?)" as a tooltip$/) do |label, tooltip|
  debugger
  page.should have_css("td[title=\"#{tooltip}\"][data-toggle=\"tooltip\"]:contains('#{label}')")
end
