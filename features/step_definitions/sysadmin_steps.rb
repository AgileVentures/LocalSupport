require 'webmock/cucumber'
require 'uri-handler'
include ApplicationHelper

And(/^sysadmin restores "(.*?)" from the console$/) do |email|
  User.only_deleted.find_by_email(email).recover
end