Then /the following tooltips should exist/ do |tooltips_table|
  tooltips_table.hashes.each do |tooltip|
    page.find('tr', :text => tooltip['label']).should have_css("td[title=\"#{tooltip['tooltip']}\"][data-toggle=\"tooltip\"]")
  end
end

Then /the following checkbox tooltips should exist/ do |tooltips_table|
  tooltips_table.hashes.each do |tooltip|
    page.find('tr', :text => tooltip['label']).should have_css("td[title=\"#{tooltip['tooltip']}\"][data-toggle=\"tooltip\"]")
  end
end
