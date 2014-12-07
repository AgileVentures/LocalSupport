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
      | Indian Elders Association      | Care for the elderly           | 64 pinner road | HA1 4HA  | http://b.com/ |
      | Age UK                         | Care for the Elderly           | 84 pinner road | HA1 4HF  | http://c.com/ |
      | Youth UK                       | Care for the Very Young        | 84 pinner road | HA1 4HF  | http://d.com/ |

    Given the following users are registered:
      | email                         | password | organisation | confirmed_at         |
      | registered_user-3@example.com | pppppppp | Youth UK     | 2007-01-01  10:00:00 |

  @javascript
  Scenario: Show all charities on homepage map
    Given I visit the home page
    Then I should see the following markers in the map:
      | Indian Elders Association | Age UK | Harrow Bereavement Counselling |

  Scenario: Clickable hyperlinks to charity homepage in map
    Given I visit the home page
    And I should see hyperlinks for "Indian Elders Association", "Age UK" and "Harrow Bereavement Counselling" in the map

  @time_travel
  Scenario Outline: Organisation map has small icon for organisations updated more than 365 days ago
    Given I travel "<days>" days into the future
    And I visit the home page
    Then the organisation "Youth UK" should have a <size> icon
    Examples: 
      |days  | size |
      | 2    | large|
      |100   | large|
      |200   | large|
      |364   | large|
      |365   | small|
      |366   | small|
      |500   | small|

  Scenario: Organisation map has small icon for organisation with no users
    Given I visit the home page
    Then the organisation "Indian Elders Association" should have a small icon

  Scenario: Changing address on the map changes the map coordinates
    Given I visit the home page
    Then the coordinates for "Harrow Bereavement Counselling" and "Youth UK" should not be the same
    And the coordinates for "Age UK" and "Youth UK" should be the same
    Given cookies are approved
    When I am signed in as a charity worker related to "Youth UK"
    And I update "Youth UK" charity address to be "34 pinner road"
    And I visit the home page
    Then the coordinates for "Harrow Bereavement Counselling" and "Youth UK" should be the same
    Then the coordinates for "Age UK" and "Youth UK" should not be the same

