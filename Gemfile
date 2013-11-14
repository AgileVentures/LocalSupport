source 'http://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.14'
gem 'devise', '3.0.3'


# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# for Heroku deployment - as described in Ap. A of ELLS book
group :development, :test do
  gem 'metric_fu'
  gem 'sqlite3'  
  gem 'database_cleaner', '1.0.1'
  gem 'launchy'
  gem 'simplecov'
  gem 'rspec-rails'
  gem 'execjs'
  gem 'rack_session_access'
  gem 'simplecov', :require => false
end

group :development do
  #gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'debugger'
  gem 'railroady'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'minitest', '~> 4.7.1'
  gem 'ZenTest'
  gem 'capybara', '2.0.2'
  gem "capybara-webkit", "~> 1.0.0"
  gem 'webrat'
  gem 'factory_girl_rails', :require => false
  gem 'webmock'
  gem 'uri-handler'
  gem 'selenium'
  gem 'selenium-client'
end

group :production do
  gem 'pg'
  gem 'newrelic_rpm'
end


# Gems used only for assets and not required
# in production environments by default.

group :assets do
  gem 'coffee-rails'#, "~> 3.1.0"
  gem 'uglifier'
  gem 'sass-rails'
  gem 'less-rails'
  gem 'twitter-bootstrap-rails'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

gem 'therubyracer'
gem 'gmaps4rails'
#gem 'mongrel'
gem 'kaminari'
gem 'unicorn'

# To use markdown in editing static pages
gem 'redcarpet'

# Adding font awesome
gem 'font-awesome-rails'

# Cookie policy gem
gem 'rack-policy'