require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir  = 'features/cassettes'
end

VCR.cucumber_tags do |t|
  t.tag '@disallowed', :record => :none
  t.tag  '@vcr', :use_scenario_name => true
end