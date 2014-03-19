require 'simplecov'
SimpleCov.start 'rails'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#
require 'capybara'
require 'capybara-webkit'
require 'capybara/rspec'
require 'factory_girl_rails'
require 'rack_session_access/capybara'
require 'webmock/rspec'
require_relative './authentication_helper'
Capybara.javascript_driver = :webkit

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
  config.include Devise::TestHelpers, :type => :view
  config.include Devise::TestHelpers, :type => :controller
  config.include Devise::TestHelpers, :type => :helper
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  #TODO: Is this too hackish to clear something that smells fixture like?  Move to
  #other testing framework?  See:
  #https://github.com/rspec/rspec-rails/issues/661
  config.before(:each) { ActionMailer::Base.deliveries.clear }
  
  config.include FactoryGirl::Syntax::Methods
  config.include ControllerHelpers, :helpers => :controllers
  config.include RequestHelpers, :helpers => :requests
end