Feature: List recurring events
  As a member of the public
  So that I can find recurring events in my area
  I would like to see a list of recurring events and when they happen

  Background: Events have been added to the database
    Given the following organisations exist:
      | name            | description          | address        | postcode | website       |
      | Cats Are Us     | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Office Primer   | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
    Given the following events exist:
      | title          | description                        | organisation  | start_date       | end_date         | recurring |
      | My first event | Good for everyone                  | Cats Are Us   | 2030-10-20 10:40 | 2030-10-20 10:50 | daily     |
      | An Event today | Testing the calendar functionality | Office Primer | today            | today            | never     |

    @javascript
    Scenario: Creating events
      Given I visit the events page
      Then I should see "My first event"
      And I should see "An Event today" within "calendar"
      And I should see "An Event today" within "events_scroll"
      And I should see "Start: Sunday, October 20, 2030 at 10:40"
      And I should see "End: Sunday, October 20, 2030 at 10:50"
      And I should see "Start: Monday, October 21, 2030 at 10:40"
      And I should see "End: Monday, October 21, 2030 at 10:50"
