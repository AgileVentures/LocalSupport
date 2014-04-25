Feature: Map of local charities
  As a local resident
  So that I can get support for a specific condition
  I want to find contact details for a local service specific to my need
  Tracker story ID: https://www.pivotaltracker.com/story/show/45757075
  Tracker story ID: https://www.pivotaltracker.com/story/show/52317013
Background: 
   Given the following organizations exist:
  | name                            | description                      | address        | postcode | website       |
  | Harrow Bereavement Counselling  | Harrow Bereavement Counselling   | 34 pinner road | HA1 4HZ  | http://a.com/ |
  | Indian Elders Association       | Care for the elderly             | 64 pinner road | HA1 4HA  | http://b.com/ |
  | Age UK                          | Care for the Elderly             | 84 pinner road | HA1 4HF  | http://c.com/ |
  | Youth UK                        | Care for the Very Young          | 84 pinner road | HA1 4HF  | http://d.com/ |

   Given the following users are registered:
  | email             | password | organization | confirmed_at |
  | registered_user-3@example.com | pppppppp | Youth UK  | 2007-01-01  10:00:00 |

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

