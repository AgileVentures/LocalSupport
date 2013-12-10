Feature: Approve cookies
  As the system owner
  In order to comply with the EU ePrivacy Directive
  I want all users to be given choice to approve cookie policy
  Tracker story ID: https://www.pivotaltracker.com/story/show/56438038

  Background:
    Given I am on the home page
  Scenario: Present the user with a choice of accepting sites cookie policy
    Given I have not approved cookie policy
    Then I should see an approve cookie policy message

  Scenario: Do not show the cookie policy alert
    Given I have approved cookie policy
    Then I should not see an approve cookie policy message

