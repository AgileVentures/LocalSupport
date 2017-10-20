Feature: View one event
  As a user of the community
  So that i can get details about an event i am interested in
  Then I should see all the details

  Background: The following events have been added to the database

    Given the following events exist:
      | title               | description       |
      | Open Source Weekend | Good for everyone |
      | Lazy Weekend        | Also good         |


  Scenario: User visits event from events page
    Given I visit the events page
    When I click "Open Source Weekend"
    Then I should see "Open Source Weekend"
    And I should not see "Lazy Weekend"

  Scenario: User visits event directly
    Given I visit "Open Source Weekend" event
    Then I should see "Open Source Weekend"
    And I should see "Good for everyone"
