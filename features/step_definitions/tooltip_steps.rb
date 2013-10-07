Then(/^the "(.*?)" label should display a tooltip$/) do |arg1|
  #page.should have_css('div.title = "first tooltip"')
  page.should have_css("div#title", :text => "First Tooltip")
  #page.should have_selector('div', :class => 'field')
end
