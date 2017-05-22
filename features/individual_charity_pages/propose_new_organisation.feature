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

    And that the automated_propose_org flag is enabled
    And I visit the home page
    And I click "Close"

  @javascript @billy
  Scenario: Link not live when feature flag disabled
    Given that the automated_propose_org flag is disabled
    And I visit the home page
    Then I should not see an add organisation link

  @vcr
  Scenario: Get validation error proposing new charity
    Given I click "Add Organisation"
    Then I should be on the new proposed organisation page
    And I press "Create Proposed organisation"
    Then I should see "Name can't be blank"
    Then I should see "Description can't be blank"
  
  @vcr
  Scenario: After getting validation error when creating new organisation checked categories are still visible
    Given I click "Add Organisation"
    Then I should be on the new proposed organisation page
    And I check the category "Child welfare"
    And I check the category "Health"
    And I press "Create Proposed organisation"
    Then the category named Child welfare should be checked
    Then the category named Health should be checked

  @javascript @vcr @billy
  Scenario: Unregistered user proposes new organisation
    Given I click "Add Organisation"
    Then I should be on the new proposed organisation page
    And I fill in the proposed charity page validly
    When I check the confirmation box for "We are a not for profit organisation registered or working in Harrow"
    And I press "Create Proposed organisation"
    And I should see all the proposed organisation fields
    And the proposed organisation should have been created
    And I should be on the proposed organisations show page for the organisation
    And the proposed organisation "Friendly charity" should have a small icon
    Then I should not see an "Accept Proposed Organisation" button
    And I should not see a "Reject Proposed Organisation" button

  @javascript @vcr @billy
  Scenario: Unregistered user proposes new organisation without checking confirmation box
    Given I click "Add Organisation"
    Then I should be on the new proposed organisation page
    And I fill in the proposed charity page validly
    When I uncheck the confirmation box for "We are a not for profit organisation registered or working in Harrow"
    And I press "Create Proposed organisation"
    And I should see all the proposed organisation fields
    And the proposed organisation should have been created
    And I should be on the proposed organisations show page for the organisation
    And the proposed organisation "Friendly charity" should have a small icon
    Then I should not see an "Accept Proposed Organisation" button
    And I should not see a "Reject Proposed Organisation" button


  @javascript @vcr @billy
  Scenario: Signed in user proposes new organisation
    Given the following users are registered:
      | email                     | password | superadmin | organisation | confirmed_at         |
      | normal_user@example.com   | pppppppp |            |              | 2007-01-01  10:00:00 |
    And I am signed in as a non-siteadmin
    And I visit the home page
    And I click "Add Organisation"
    Then I should be on the new proposed organisation page
    And I fill in the proposed charity page validly
    And I check the confirmation box for "We are a not for profit organisation registered or working in Harrow"
    And I press "Create Proposed organisation"
    And I should see "This organisation proposed by 'normal_user@example.com'"
    And the proposed organisation should have been created
    And I should see all the proposed organisation fields
    And I should be on the proposed organisations show page for the organisation
    And the proposed organisation "Friendly charity" should have a large icon

  @javascript @vcr @billy
  Scenario: Superadmin receives an email when an organisation is proposed
    Given the following users are registered:
      | email                     | password | superadmin | organisation | confirmed_at         |
      | superadmin@example.com    | pppppppp | true       |              | 2007-01-01  10:00:00 |
    And I click "Add Organisation"
    Then I should be on the new proposed organisation page
    And I fill in the proposed charity page validly
    When I uncheck the confirmation box for "We are a not for profit organisation registered or working in Harrow"
    And I press "Create Proposed organisation"
    And I should see all the proposed organisation fields
    And the proposed organisation should have been created
    Then an email should be sent to "superadmin@example.com" as notification of the proposed organisation
