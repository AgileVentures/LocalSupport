VCR.configure do |config|
  config.ignore_localhost = true
  config.cassette_library_dir = "features/vcr_cassettes"
  config.hook_into :webmock
  config.debug_logger = File.open('vcr.log', 'w')
  config.default_cassette_options = { record: :new_episodes }
  config.ignore_request do |request|
    request.headers.include?('Referer')
  end
  config.filter_sensitive_data("<KCSC_API_KEY>") { ENV['KCSC_API_KEY'] }
  config.filter_sensitive_data("<GMAP_API_KEY>") { ENV['GMAP_API_KEY'] }
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr', :use_scenario_name => true
end
