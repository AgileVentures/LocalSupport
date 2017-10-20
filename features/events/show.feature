Feature: View one event
  As a user of the community
  So that i can get details about an event i am interested in
  Then I should see all the details

  Background: The following events have been added to the database

    Given the following events exist:
      | title               | description       | start_date          | end_date            |
      | Open Source Weekend | Good for everyone | 2030-10-20 10:30:14 | 2030-10-20 17:00:00 |
      | Lazy Weekend        | Also good         | 2055-02-02 08:00:00 | 2055-02-02 17:00:00 |


  Scenario: User visits event from events page
    Given I visit the events page
    Then show me the page
    When I click "Open Source Weekend"
    Then I should see "Open Source Weekend"
    And I should not see "Lazy Weekend"

  Scenario: User visits event directly
    Given I visit "Open Source Weekend" event
    Then I should see "Open Source Weekend"
    And I should see "Good for everyone"
    And I should see "Sunday, October 20, 2030 at 10:30"
