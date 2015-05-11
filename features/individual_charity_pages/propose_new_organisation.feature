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
  Scenario: Unregistered User
    Given I click "Add Organisation"
    Then I should be on the home page
    #And I click "toggle_link"
    When I sign up as "normal_user@myorg.com" with password "pppppppp" and password confirmation "pppppppp"
    Then I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
    And I should be on the new proposed organisation page
    And I fill in the proposed charity page validly including the categories:
      | name              |
      | Animal welfare    |
      | Accommodation     |
      | Education         |
      | Give them things  |
    And I press "Create Proposed organisation"
    And I should see "This organisation proposed by 'normal_user@myorg.com'"

