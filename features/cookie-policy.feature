Feature: Approve cookies
  As the system owner
  In order to comply with the EU ePrivacy Directive
  I want all users to be given choice to approve cookie policy
  Tracker story ID: https://www.pivotaltracker.com/story/show/56438038

  Background:
    Given the following users are registered:
      | email                            | password | confirmed_at        |
      | registered-user@example.com      | pppppppp | 2014-01-20 16:27:36 |
    Given I receive a new password for "registered-user@example.com"
    Then I should be on the password reset page
    And I should see an approve cookie policy message

  Scenario: User approving the cookies
    Given I click "Close"
    Then I should not see an approve cookie policy message
    And I should be on the password reset page