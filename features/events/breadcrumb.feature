Feature: View Breadcrumbs
  As a user of the community
  So that I can easily backtrace my steps in the application
  I would like to have breadcrumbs properly displayed

  Background: The following events have been added to the database
    Given the following organisations exist:
      | name            | description          | address        | postcode | website       |
      | Cats Are Us     | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Office Primer   | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |

    Given the following events exist:
      | title               | description       | organisation  | start_date          | end_date            | start_time | end_time |
      | Open Source Weekend | Good for everyone | Cats Are Us   | 2030-10-20 10:30:14 | 2030-10-20 17:00:00 | 10:30      | 17:00    |
      | Lazy Weekend        | Also good         | Office Primer | 2055-02-02 08:00:00 | 2055-02-02 17:00:00 | 08:00      | 17:00    |


  Scenario: User visits event home page
    Given I visit the events page
    Then I should see a link to "home" page "/"
    And I should see "home » Events"
 
  Scenario: User visits event from events page
    Given I visit the events page
    When I click "Open Source Weekend"
    Then I should see a link to "home" page "/"
    And I should see a link to "Events" page "/events"
    And I should see "home » Events » Open Source Weekend"
