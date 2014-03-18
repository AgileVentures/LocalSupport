Feature: Approve cookies
  As the system owner
  In order to comply with the EU ePrivacy Directive
  I want all users to be given choice to approve cookie policy
  Tracker story ID: https://www.pivotaltracker.com/story/show/56438038

  Background:
    Given I am on the password reset page
    Then I should see an approve cookie policy message

  Scenario: User approving the cookies
    Given I click "Close"
    Then I should not see an approve cookie policy message
    And I should be on the password reset page

  @javascript
  Scenario: Check that cookies can be approved even with JavaScript
    Given I click "Close"
    Then I should not see an approve cookie policy message
    And I should be on the password reset page


