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
  @contributors.select do |contributor|
    contributor["login"] == name
    avatar = contributor['avatar_url']
    link = contributor['html_url']
    page.should have_css("a[href='#{link}'] img[src='#{avatar}']")
  end
end

