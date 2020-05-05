source 'https://rubygems.org'

ruby '2.6.5'
gem 'rails', '~> 5.2.4'
gem 'pg', '~> 1.2'
gem 'devise', '~> 4.7'
gem 'devise_invitable', '~> 2.0'
gem 'heroku-api'
gem 'sprockets'

gem 'fullcalendar-rails'
gem 'bootstrap3-datetimepicker-rails'
gem 'momentjs-rails'
gem 'jbuilder'
gem 'puma'
gem 'rack-cors'

gem 'report_intermittent_fails', git: 'https://github.com/tansaku/report_intermittent_fails', branch: 'randomfail-endtoend'
#, git: 'https://github.com/tansaku/report_intermittent_fails'
#, path: '/Users/tansaku/Documents/GitHub/tansaku/report_intermittent_fails/'


# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# for Heroku deployment - as described in Ap. A of ELLS book
group :development, :test do
  gem 'annotate'
  gem 'faker', '~> 2.11'
  gem 'timecop'
  gem 'database_cleaner', '1.8.3'
  gem 'launchy'
  gem 'simplecov', require: false
  gem 'sinatra'
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'execjs'
  gem 'aruba', '~> 0.14.14'
  gem 'pry-byebug'
  gem 'rack_session_access'
  gem 'jasmine', '~> 3.5'
  gem 'jasmine-jquery-rails', '2.0.3'
  gem 'rails-controller-testing'
  #gem 'better_errors'
  gem 'binding_of_caller' # plays well with better_errors
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

group :development do
  gem 'rubocop-git'
  gem 'letter_opener'
  gem 'railroady'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'cucumber-rails-training-wheels'
  gem 'capybara', '~> 3.31'
  gem 'nokogiri', '~> 1.10'
  gem 'factory_bot_rails'
  gem 'webmock', '~> 3.8'
  gem 'uri-handler'
  gem 'selenium'
  gem 'selenium-client'
  gem 'shoulda'
  gem 'vcr'
  gem 'puffing-billy', '~> 2.3'
  gem 'poltergeist'
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'show_me_the_cookies', '~> 5.0'
  gem 'rubocop-rspec', '>=1.28'
end

group :production do
  gem 'newrelic_rpm'
end

gem 'coffee-rails', '5.0.0'
gem 'uglifier'
gem 'sass-rails', '~> 6.0'
gem 'less-rails', '~> 4.0'
gem 'twitter-bootstrap-rails', '3.2.2'

gem 'font-awesome-rails'

gem 'jquery-rails'
gem 'bootstrap_sortable_rails', '~> 1.11.2'
gem 'breadcrumbs_on_rails'
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
gem 'sucker_punch', '~> 2.1' # async job
gem 'rails_autolink'
gem 'paranoia', '~> 2.4'

gem 'dotenv-rails'
gem 'figaro'
gem 'airbrake'

# Using user friendly names in URLs
gem 'friendly_id', '~> 5.3.0'

# SEO
gem 'meta-tags', '~> 2.13'

#Social
gem 'twitter',      '~> 7.0'
gem 'twitter-text', '~> 3.1'
gem 'koala' # Facebook integration

# Admin

gem 'administrate'
