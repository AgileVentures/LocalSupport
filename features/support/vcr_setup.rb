require 'vcr'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = false
  c.default_cassette_options = { :record => :new_episodes }
  c.cassette_library_dir = 'features/vcr_cassettes'
  c.hook_into :webmock
  # c.ignore_localhost = true
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr', :use_scenario_name => true
end