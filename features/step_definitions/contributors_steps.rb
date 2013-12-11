Given(/^the following contributors exist:$/) do |c_table|
  contributors = Array.new
  c_table.hashes.each do |contributor|
    contributors << contributor
  end
  stub_request(:get, 'https://api.github.com/repos/tansaku/LocalSupport/contributors')
  .to_return(:body => contributors.to_json)
end