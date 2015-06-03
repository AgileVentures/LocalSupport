Feature: User proposes an organisation to be added to HarrowCN
  As a person affiliated with an organisation
  So that I can increase my organisation's visibility
  I propose to add my organisation to HarrowCN
  Tracker story ID: https://www.pivotaltracker.com/story/show/742821

  Background:

    Given the following categories exist:
      | name              | charity_commission_id |
      | Animal welfare    | 101                   |
      | Child welfare     | 102                   |
      | Feed the hungry   | 103                   |
      | Accommodation     | 203                   |
      | General           | 204                   |
      | Health            | 202                   |
      | Education         | 303                   |
      | Give them things  | 304                   |
      | Teach them things | 305                   |

    And I visit the home page
    And I click "Close"

  @javascript
  Scenario: Unregistered user proposes new organisation
    Given I click "Add Organisation"
    Then I should be on the home page
    When I sign up as "normal_user@myorg.com" with password "pppppppp" and password confirmation "pppppppp"
    Then I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
    And I should be on the new proposed organisation page
    And I fill in the proposed charity page validly
    And I press "Create Proposed organisation"
    And I should see "This organisation proposed by 'normal_user@myorg.com'"
    And the proposed organisation should have been created
    And I should see all the proposed organisation fields
    And I should be on the proposed organisations show page for the organisation
    And the proposed organisation "Friendly charity" should have a large icon
    Then I should not see an "Accept Proposed Organisation" button
    And I should not see a "Reject Proposed Organisation" button

  @javascript
  Scenario: Unregistered user fails to signup once and then successfully proposes new organisation
    Given I click "Add Organisation"
    Then I should be on the home page
    When I sign up as "normal_user@myorg.com" with password "pppppppp" and password confirmation "pppppppx"
    Then I should see "Password confirmation doesn't match Password"
    And I sign up as "normal_user@myorg.com" with password "pppppppp" and password confirmation "pppppppp" on the legacy sign up page
    Then I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
    And I should be on the new proposed organisation page
    And I fill in the proposed charity page validly
    And I press "Create Proposed organisation"
    And I should see "This organisation proposed by 'normal_user@myorg.com'"
    And the proposed organisation should have been created
    And I should see all the proposed organisation fields
    And I should be on the proposed organisations show page for the organisation
    And the proposed organisation "Friendly charity" should have a large icon

  @javascript
  Scenario: Signed in user proposes new organisation
    Given the following users are registered:
      | email                     | password | superadmin | organisation | confirmed_at         |
      | normal_user@example.com   | pppppppp |            |              | 2007-01-01  10:00:00 |
    And I am signed in as a non-siteadmin
    And I visit the home page
    And I click "Add Organisation"
    Then I should be on the new proposed organisation page
    And I fill in the proposed charity page validly
    And I press "Create Proposed organisation"
    And I should see "This organisation proposed by 'normal_user@example.com'"
    And the proposed organisation should have been created
    And I should see all the proposed organisation fields
    And I should be on the proposed organisations show page for the organisation
    And the proposed organisation "Friendly charity" should have a large icon
