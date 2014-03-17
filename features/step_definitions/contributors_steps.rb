Given(/^I am on the contributors page$/) do
  visit contributors_path
end


Given(/^the following contributors exist:$/) do |c_table|
  @contributors = Array.new
  c_table.hashes.each do |contributor|
    @contributors << contributor
  end
  stub_request(:get, 'https://api.github.com/repos/tansaku/LocalSupport/contributors')
  .to_return(:body => @contributors.to_json)
end


Then(/^I should see a link avatar for "([^"]*)"$/) do |name|
  @contributor = (@contributors.find do |contributor|
    contributor['login'] == name
  end)
  avatar = @contributor['avatar_url']
  link = @contributor['html_url']
  page.should have_css("a[href='#{link}'] img[src='#{avatar}']")
end

Then(/^I follow the AgileVentures logo$/) do
  visit page.find(:xpath, "//a/img[@alt='Agile Ventures Local Support']/..")['href']
end
