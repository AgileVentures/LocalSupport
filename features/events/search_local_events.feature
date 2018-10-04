@javascript @vcr @billy
Feature: Search local events
  As a member of the public
  So that I can find out what's going on locally
  I want to search upcoming events

  Background: Events have been added to the database
    Given the following organisations exist:
      | name            | description          | address        | postcode | website       |
      | Cats Are Us     | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Office Primer   | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
    Given the following events exist:
      | title            | description             | organisation  | start_date       | end_date         |
      | My first event   | Still good people       | Cats Are Us   | one day from now | one day from now |
      | My second event  | Second still podium     | Office Primer | today            | today            |
      | Some past event | Look after older people | Office Primer | yesterday        | yesterday        |
    And cookies are approved
    And I visit the events page

  Scenario: Find out what's going on locally
    Given I fill in "Search Text" with "still" within the main body
    And I press "Search"
    Then I should see "Still good people"
    Then I should see "Second still podium"
    And I should not see "Some other event" within "events_scroll"
    Then I should see 2 markers in the map

  Scenario: Search a list of current events with a keyword that won't match
    Given I fill in "Search Text" with "non existent text" within the main body
    And I press "Search"
    Then I should see "Sorry, it seems we don't have quite what you are looking for."

  Scenario: Query string is visible after search
    Given I fill in "Search Text" with "search words" within the main body
    And I press "Search"
    Then the search box should contain "search words"

  Scenario: Search displays only future events
    Given I fill in "Search Text" with "Some past event" within the main body
    And I press "Search"
    Then I should see "Sorry, it seems we don't have quite what you are looking for."
