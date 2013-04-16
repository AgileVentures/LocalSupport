source 'http://rubygems.org'

gem 'rails', '3.1.10'
gem 'devise'


# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# for Heroku deployment - as described in Ap. A of ELLS book
group :development, :test do
  gem 'sqlite3'  
  gem 'database_cleaner'
  gem 'launchy'
  gem 'simplecov'
  gem 'rspec-rails'
  gem 'execjs'
  gem 'therubyracer'
end

group :development do
  gem 'ruby-debug19', :require => 'ruby-debug'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'minitest'
  gem 'ZenTest'
  gem 'capybara', '2.0.0'
  gem 'webrat'
  gem 'factory_girl_rails', :require => false
  gem 'webmock'
  gem 'uri-handler'
end
group :production do
  gem 'pg'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'#, "~> 3.1.0"
  gem 'coffee-rails'#, "~> 3.1.0"
  gem 'uglifier'
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

gem 'gmaps4rails'
gem 'devise'
#gem 'mongrel'
