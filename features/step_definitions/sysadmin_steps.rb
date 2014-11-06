require 'webmock/cucumber'
require 'uri-handler'
include ApplicationHelper

And(/^sysadmin restores "(.*?)" from the console$/) do |email|
  User.with_deleted.find_by_email(email).restore
end
