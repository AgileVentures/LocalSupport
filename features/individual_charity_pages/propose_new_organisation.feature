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

  Scenario: User wants to add a new org
    When I click "Add Organisation"
    Then I should be on the new proposed organisation page
  
  Scenario: User fills out form to add new org
    When I visit the new proposed organisation page
    And I fill in the proposed charity page validly including the categories:
      | name              |
      | Animal welfare    |
      | Child welfare     |
      | Feed the hungry   |
      | Accommodation     |
      | General           |
      | Health            |
      | Education         |
      | Give them things  |
      | Teach them things |
    And I press "Create Proposed organisation"
    Then I should be on the show page for the proposed_organisation named "Friendly charity"


