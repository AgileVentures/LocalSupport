if ENV['RACK_ENV'] != 'production'
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  desc 'Run Rspec and Cucumber tests with coveralls'
  task :test_with_coveralls => [:spec, 'cucumber:first_try', 'coveralls:push']
end
