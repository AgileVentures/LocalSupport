Given(/^the following contributors exist:$/) do |contributors|
  @contributors = contributors.hashes
  stub_request(:any, /api\.github\.com/).to_return(:body => @contributors.to_json)
end


Then(/^I should see a link avatar for "([^"]*)"$/) do |name|
  contributor = @contributors.find { |ctrb| ctrb['login'] == name }
  avatar = contributor['avatar_url']
  link = contributor['html_url']
  page.should have_css("a[href='#{link}'] img[src='#{avatar}']")
end

Then(/^I follow the AgileVentures logo$/) do
  visit page.find(:xpath, "//a/img[@alt='Agile Ventures']/..")['href']
end
