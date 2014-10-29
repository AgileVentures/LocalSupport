source 'http://rubygems.org'

ruby '1.9.3'
gem 'rails', '4.0.10'
#gem 'protected_attributes'
gem 'pg'
gem 'devise', '3.0.3'
gem 'devise_invitable', '~> 1.2.1'
gem 'heroku-api'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# for Heroku deployment - as described in Ap. A of ELLS book
group :development, :test do
  gem 'metric_fu'
  gem 'database_cleaner', '1.0.1'
  gem 'launchy'
  gem 'simplecov'
  gem 'rspec-rails', '2.14.2'
  gem 'execjs'
  gem 'aruba'
  gem 'rack_session_access'
  gem 'jasmine'
  gem 'jasmine-jquery-rails'
  #gem 'better_errors'
  gem 'binding_of_caller' # plays well with better_errors
end

group :development do
  #gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'debugger', '~> 1.6.8'
  gem 'railroady'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'minitest', '~> 4.7.1'
  gem 'ZenTest'
  gem 'capybara', '2.4.1'
  gem "capybara-webkit", "~> 1.1.0"
  gem 'webrat'
  gem 'factory_girl_rails', :require => false
  gem 'webmock'
  gem 'uri-handler'
  gem 'selenium'
  gem 'selenium-client'
end

group :production do
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

gem 'font-awesome-rails'

gem 'jquery-rails'
gem 'bootstrap_sortable_rails', '~> 0.1.3'

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
gem 'gmaps4rails', '1.5.6'
#gem 'mongrel'
gem 'kaminari'
gem 'unicorn'

# To use markdown in editing static pages
gem 'redcarpet'

# validating organisation website URLs
gem 'url_validator'


gem 'rails_autolink'
gem "paranoia", "~> 2.0"
