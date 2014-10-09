Then /the following tooltips should exist/ do |tooltips_table|
  tooltips_table.hashes.each do |tooltip|
    expect(page).to have_xpath("//tr/td[@title='#{tooltip['tooltip']}'][@data-toggle=\"tooltip\"]")
  end
end
