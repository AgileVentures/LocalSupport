Feature: View one event
  As a user of the community
  I would like to get details about an event i am interested in
  Therefore I should see the details on a certain page

  Background: The following event has been added to the database

    Given the following events exist:
      | title               | description       |
      | Open Source Weekend | Good for everyone |
      | Lazy Weekend        | Also good         |


  Scenario: User visits event from events page
    Given I visit "events"
    When I click "Open Source Weekend"
    Then I should see "Open Source Weekend"
    And I should not see "Lazy Weekend"

  Scenario: User visits event directly
    Given I visit "Open Source Weekend" event
    Then I should see "Open Source Weekend"
    And I should see "Good for everyone"
