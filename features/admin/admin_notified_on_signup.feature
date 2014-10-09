Feature: Site admin notified of new signups
  As a site admin
  So that I can be responsive to new users
  I want to be notified when they sign up
#  Tracker story ID: https://www.pivotaltracker.com/story/show/59112122

  Background:
    Given the following users are registered:
      | email                | password | admin | confirmed_at         | organisation |
      | admin@harrowcn.com   | pppppppp | true  | 2007-01-01  10:00:00 | Friendly     |
      | admin2@harrowcn.com  | pppppppp | true  | 2007-01-01  10:00:00 | Friendly     |
    And the email queue is clear
    And cookies are approved

  Scenario: Email is sent when new user signs up
    Given I visit the sign up page
    When I sign up as "non-existent-user@example.com" with password "pppppppp" and password confirmation "pppppppp"
    Then an email should be sent to "admin@harrowcn.com" as notification of the signup by email "non-existent-user@example.com"
    And an email should be sent to "admin2@harrowcn.com" as notification of the signup by email "non-existent-user@example.com"

