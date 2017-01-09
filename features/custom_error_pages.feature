@allow-rescue @in-production
Feature: I want to make error pages follow the general design of the site.
  As a site superadministrator
  So that site users are not alarmed when I enter an incorrect URL
  I want custom error pages, rendered in-line with the rest of the site
  Pivotal Tracker story:  https://www.pivotaltracker.com/story/show/60838900

  Scenario: 404 page when visiting an invalid URL
    When I visit "/foobar"
    And the page should be titled "404 Page Not Found"
    And the response status should be "404"
    And I should see "We're sorry, but we couldn't find the page you requested"

  Scenario: 404 page when opening an invalid project
    When I visit "/organisations/foo-bar-org"
    And the page should be titled "404 Page Not Found"
    And the response status should be "404"
    And I should see "We're sorry, but we couldn't find the page you requested"

  Scenario: 500 page
    When I encounter an internal server error
    Then the page should be titled "500 Internal Server Error"
    And the response status should be "500"
    And I should see "We're sorry, but something went wrong."

  Scenario: reset_password_token expired message
    Given I requested a new password too long ago
    When I visit the reset password page
    And I try to reset my password
    Then I should see "Reset requested too long ago - please request a new reset by clicking "forgot password" again" within "error_explanation"
