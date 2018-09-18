VCR.configure do |config|
  config.ignore_localhost = true
  config.cassette_library_dir = "features/vcr_cassettes"
  config.hook_into :webmock
  config.debug_logger = File.open('vcr.log', 'w')
  config.default_cassette_options = {
    clean_outdated_http_interactions: true,
    re_record_interval: 1.month.to_i,
    record: :new_episodes }
  config.ignore_request do |request|
    request.headers.include?('Referer')
  end
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr', :use_scenario_name => true
end
