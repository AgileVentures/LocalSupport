@time_travel @maps
Feature: Map of local events
  As a member of the public
  So that I can work out how to attend an event/see which events are nearest to me
  I would like to see a map of event locations
  Tracker story ID: https://www.pivotaltracker.com/story/show/67698608

  Background:
    Given today's date is 1980-12-25

    Given the following organisations exist:
      | name          | description          | address        | postcode | website       |
      | Cats Are Us   | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Office Primer | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |

    Given the following events exist:
      | title          | description                        | organisation  | start_date          | end_date            |
      | My first event | Good for everyone                  | Cats Are Us   | 2030-10-20 10:30:14 | 2030-10-20 17:00:00 |
      | An Event today | Testing the calendar functionality | Office Primer | today               | today               |

  @javascript @vcr @billy @fix-ci
  Scenario: Show all events in map on events page map
    Given I visit the events page
    Then I should see the following event markers in the map:
      | Cats Are Us | Office Primer |

  @javascript @billy @fix-ci
  Scenario: Infowindow appears when clicking on map marker
    Given I visit the events page
    Then I should see an infowindow when I click on the event map markers:
      | My first event | An Event today |
