source 'https://rubygems.org'

ruby '2.4.2'
gem 'rails', '~> 4.2', '>= 4.2.7.1'
gem 'pg', '0.20' # locked to 0.20 due to https://github.com/rails/rails/issues/29521
gem 'devise', '~> 3.5', '>= 3.5.10'
gem 'devise_invitable', '~> 1.6', '>= 1.6.1'
gem 'heroku-api'
gem 'sprockets', '~> 2.11', '>= 2.11.3'

gem 'fullcalendar-rails'
gem 'momentjs-rails'
gem 'jbuilder'


# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# for Heroku deployment - as described in Ap. A of ELLS book
group :development, :test do
  gem 'timecop'
  gem 'database_cleaner', '1.0.1'
  gem 'launchy'
  gem 'simplecov'
  gem 'sinatra'
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'execjs'
  gem 'aruba'
  gem 'byebug'
  gem 'rack_session_access'
  gem 'jasmine', '~> 2.4'
  gem 'jasmine-jquery-rails', '2.0.2'
  #gem 'better_errors'
  gem 'binding_of_caller' # plays well with better_errors
end

group :development do
  gem 'rubocop-git'
  gem 'letter_opener'
  gem 'railroady'
  gem 'quiet_assets'

end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'capybara', '2.4.4'
  gem 'capybara-webkit', '~> 1.6.0'
  gem 'nokogiri', '~> 1.7.2'
  gem 'factory_bot_rails'
  gem 'webmock'
  gem 'uri-handler'
  gem 'selenium'
  gem 'selenium-client'
  gem 'coveralls', '~> 0.8.21'
  gem 'shoulda'
  gem 'vcr'
  gem 'puffing-billy'
  gem 'poltergeist'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
  gem 'show_me_the_cookies'
end

group :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end

gem 'coffee-rails', "4.1.0"
gem 'uglifier', '~> 3.0', '>= 3.0.3'
gem 'sass-rails', '~> 4.0', '>= 4.0.5'
gem 'less-rails', '2.5.0'
gem 'twitter-bootstrap-rails', '3.2.0'

gem 'font-awesome-rails'

gem 'jquery-rails'
gem 'bootstrap_sortable_rails', '~> 1.11.2'
gem 'breadcrumbs_on_rails'
gem 'bootstrap-datepicker-rails'
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'therubyracer'
gem 'underscore-rails'
gem 'geocoder'
gem 'unicorn'

# To use markdown in editing static pages
gem 'redcarpet'

# validating organisation website URLs
gem 'url_validator', git: 'https://github.com/AgileVentures/url_validator.git'

gem 'httparty'
gem 'sucker_punch', '~> 2.0' # async job
gem 'rails_autolink'
gem "paranoia", "~> 2.0"

gem 'dotenv-rails'
gem 'figaro'
gem 'airbrake'

# Using user friendly names in URLs
gem 'friendly_id', '~> 5.1.0'

# SEO
gem 'meta-tags'
