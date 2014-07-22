Then /the following tooltips should exist/ do |tooltips_table|
  tooltips_table.hashes.each do |tooltip|
    page.has_xpath?("//tr/td[@title='#{tooltip['tooltip']}'][@data-toggle=\"tooltip\"]")
  end
end
