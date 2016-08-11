source 'https://rubygems.org'

ruby '2.3.1'
gem 'rails', '~> 4.2.0'
gem 'pg'
gem 'devise', '~> 3.4.0'
gem 'devise_invitable', '~> 1.3.0'
gem 'heroku-api'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# for Heroku deployment - as described in Ap. A of ELLS book
group :development, :test do
  gem 'timecop'
  gem 'database_cleaner', '1.0.1'
  gem 'launchy'
  gem 'simplecov'
  gem 'sinatra-base'
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'execjs'
  gem 'aruba'
  gem 'byebug'
  gem 'rack_session_access'
  gem 'jasmine', github: 'AgileVentures/jasmine-gem'
  gem 'jasmine-jquery-rails', '2.0.2'
  #gem 'better_errors'
  gem 'binding_of_caller' # plays well with better_errors
end

group :development do
  #gem 'ruby-debug19', :require => 'ruby-debug'
  #gem 'debugger', '~> 1.6.8'
  gem "letter_opener"
  gem 'railroady'
  gem 'quiet_assets'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'capybara', '2.4.1'
  gem "capybara-webkit", "~> 1.6.0"
  gem 'factory_girl_rails', :require => false
  gem 'webmock', '1.20.0'
  gem 'uri-handler'
  gem 'selenium'
  gem 'selenium-client'
  gem 'coveralls', require: false
  gem 'shoulda'
  gem 'vcr'
  gem 'puffing-billy'
  gem 'poltergeist'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
end

group :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end

gem 'coffee-rails', "4.1.0"
gem 'uglifier', '2.5.3'
gem 'sass-rails', '4.0.3'
gem 'less-rails', '2.5.0'
gem 'twitter-bootstrap-rails', '2.2.8'

gem 'font-awesome-rails'

gem 'jquery-rails'
gem 'bootstrap_sortable_rails', '~> 0.1.3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'therubyracer'
gem 'underscore-rails'
gem 'geocoder'
gem 'gmaps4rails', "2.1.2"
gem 'unicorn'

# To use markdown in editing static pages
gem 'redcarpet'

# validating organisation website URLs
gem 'url_validator', git: 'https://github.com/AgileVentures/url_validator.git'

gem 'httparty'

gem 'rails_autolink'
gem "paranoia", "~> 2.0"

gem 'dotenv-rails'
gem 'airbrake'

# Using user friendly names in URLs
gem 'friendly_id', '~> 5.1.0'
