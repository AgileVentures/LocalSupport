Feature: Map of local charities
  As a local resident
  So that I can get support for a specific condition
  I want to find contact details for a local service specific to my need
  Tracker story ID: https://www.pivotaltracker.com/story/show/45757075
  Tracker story ID: https://www.pivotaltracker.com/story/show/52317013

  Background:
    Given the following organisations exist:
      | name                           | description                    | address        | postcode | website       |
      | Harrow Bereavement Counselling | Harrow Bereavement Counselling | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association      | Care for the elderly           | 64 pinner road | HA1 4HZ  | http://b.com/ |
      | Age UK                         | Care for the Elderly           | 84 pinner road | HA1 4HZ  | http://c.com/ |
      | Youth UK                       | Care for the Very Young        | 84 pinner road | HA1 4HZ  | http://d.com/ |

    Given the following users are registered:
      | email                         | password | organisation | confirmed_at         |
      | registered_user-3@example.com | pppppppp | Youth UK     | 2007-01-01  10:00:00 |
 
  @vcr
  @javascript
  Scenario: Show all charities in map on homepage map
    Given I visit the home page
    Then I should see the following measle markers in the map:
      | Indian Elders Association | Age UK | Harrow Bereavement Counselling |

  @vcr
  @javascript
  Scenario: Infowindow appears when clicking on map marker
    Given I visit the home page
    Then I should see an infowindow when I click on the map markers:
      | Indian Elders Association | Age UK | Harrow Bereavement Counselling |
  
  @vcr
  @time_travel
  @javascript
  Scenario Outline: Organisation map has small icon for organisations updated more than 365 days ago
    Given I travel a year plus "<days>" days into the future
    And I visit the home page
    Then the organisation "Youth UK" should have a <size> icon
    Examples:
      |days  | size |
      | -10  | large|
      | -1   | large|
      |  0   | small|
      |  1   | small|
      | 10   | small|
      |100   | small|

  @vcr
  @javascript
  Scenario: Organisation map has small icon for organisation with no users
    Given I visit the home page
    Then the organisation "Indian Elders Association" should have a small icon

  @vcr
  Scenario: Changing address on the map changes the map coordinates
    Given I visit the home page
    Then the coordinates for "Harrow Bereavement Counselling" and "Youth UK" should not be the same
    And the coordinates for "Age UK" and "Youth UK" should be the same
    Given cookies are approved
    When I am signed in as a charity worker related to "Youth UK"
    And I update "Youth UK" charity address to be "34 pinner road"
    And I update "Youth UK" charity postcode to be "HA1 4HZ"
    And I visit the home page
    Then the coordinates for "Harrow Bereavement Counselling" and "Youth UK" should be the same
    Then the coordinates for "Age UK" and "Youth UK" should not be the same


  @vcr

  Scenario: Show meaning of large map icons on home page
    Given I visit the home page
    And I click "Close"
    Then I should see "Details updated by the organisation within the last 12 months"
    Then I should see "Details NOT updated by the organisation within the last 12 months"

  @vcr
  Scenario: Do not show meaning of large map icons on volunteer ops page
    Given I visit the volunteer opportunities page
    And I click "Close"
    Then I should not see "Details updated by the organisation within the last 12 months"
    Then I should not see "Details NOT updated by the organisation within the last 12 months"
